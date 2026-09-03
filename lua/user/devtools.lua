local M = {}

local is_windows = vim.fn.has('win32') == 1
local executable_suffix = is_windows and '.exe' or ''
local python_candidates = is_windows and { 'python', 'python3' } or { 'python3', 'python' }

local function executable(name)
  return vim.fn.executable(name) == 1
end

local function first_executable(names)
  for _, name in ipairs(names) do
    if executable(name) then
      return name
    end
  end
end

local function project_root(markers)
  local root = vim.fs.root(0, markers)
  return root or vim.fs.dirname(vim.api.nvim_buf_get_name(0)) or vim.fn.getcwd()
end

local function show_quickfix(title, output)
  local lines = vim.split(output or '', '\n', { plain = true, trimempty = true })
  vim.fn.setqflist({}, ' ', {
    title = title,
    lines = lines,
    efm = table.concat({
      '%f:%l:%c: %t%*[^:]: %m',
      '%f:%l:%c: %m',
      '%f(%l\\,%c): %t%*[^:]: %m',
      '%f(%l): %m',
      '%-G%.%#',
    }, ','),
  })
  if #lines > 0 then
    vim.cmd('copen')
  end
end

local function run_async(label, command, cwd, on_success)
  vim.notify(label .. ': ' .. table.concat(command, ' '), vim.log.levels.INFO)
  vim.system(command, { cwd = cwd, text = true }, function(result)
    vim.schedule(function()
      local output = (result.stdout or '') .. (result.stderr or '')
      if result.code == 0 then
        vim.notify(label .. ' thành công', vim.log.levels.INFO)
        if on_success then
          on_success(output)
        end
      else
        show_quickfix(label .. ' (exit ' .. result.code .. ')', output)
        vim.notify(label .. ' thất bại; xem Quickfix', vim.log.levels.ERROR)
      end
    end)
  end)
end

local function cmake_root()
  local root = vim.fs.root(0, { 'CMakeLists.txt' })
  if not root then
    vim.notify('Không tìm thấy CMakeLists.txt trong cây thư mục hiện tại', vim.log.levels.WARN)
  end
  return root
end

function M.cmake_configure(on_success)
  local root = cmake_root()
  if not root or not executable('cmake') then
    if root then
      vim.notify('Chưa cài cmake hoặc cmake chưa có trong PATH', vim.log.levels.ERROR)
    end
    return
  end

  local build = vim.fs.joinpath(root, 'build')
  local command = { 'cmake', '-S', root, '-B', build, '-DCMAKE_EXPORT_COMPILE_COMMANDS=ON' }
  if not vim.uv.fs_stat(vim.fs.joinpath(build, 'CMakeCache.txt')) then
    if executable('ninja') then
      vim.list_extend(command, { '-G', 'Ninja' })
    elseif is_windows and executable('mingw32-make') then
      vim.list_extend(command, { '-G', 'MinGW Makefiles' })
    end
  end

  run_async('CMake configure', command, root, function()
    -- clangd watches build/compile_commands.json. Restarting makes a newly
    -- generated database effective immediately for every open C/C++ buffer.
    for _, client in ipairs(vim.lsp.get_clients({ name = 'clangd' })) do
      client:stop(true)
    end
    vim.defer_fn(function()
      if vim.bo.filetype ~= '' then
        pcall(vim.api.nvim_exec_autocmds, 'FileType', { buffer = 0, modeline = false })
      end
    end, 100)
    if on_success then
      on_success()
    end
  end)
end

function M.cmake_build()
  local root = cmake_root()
  if not root or not executable('cmake') then
    return
  end
  local build = vim.fs.joinpath(root, 'build')
  if not vim.uv.fs_stat(vim.fs.joinpath(build, 'CMakeCache.txt')) then
    M.cmake_configure(function()
      run_async('CMake build', { 'cmake', '--build', build, '--parallel' }, root)
    end)
    return
  end
  run_async('CMake build', { 'cmake', '--build', build, '--parallel' }, root)
end

function M.cmake_test()
  local root = cmake_root()
  if not root or not executable('ctest') then
    return
  end
  run_async('CTest', { 'ctest', '--test-dir', vim.fs.joinpath(root, 'build'), '--output-on-failure' }, root)
end

local function terminal(command, cwd, title)
  vim.cmd('botright new')
  vim.api.nvim_buf_set_name(0, title or 'Run')
  vim.fn.termopen(command, { cwd = cwd })
  vim.cmd('startinsert')
end

local function single_file_build(on_success)
  local file = vim.api.nvim_buf_get_name(0)
  local ft = vim.bo.filetype
  if file == '' or (ft ~= 'c' and ft ~= 'cpp') then
    vim.notify('Build file đơn chỉ hỗ trợ C/C++; project khác dùng build tool của project', vim.log.levels.WARN)
    return
  end
  vim.cmd('silent write')
  local compiler = ft == 'cpp'
      and first_executable({ vim.env.CXX or '', 'g++', 'clang++' })
      or first_executable({ vim.env.CC or '', 'gcc', 'clang' })
  if not compiler then
    vim.notify('Không tìm thấy compiler C/C++ trong PATH', vim.log.levels.ERROR)
    return
  end
  local root = vim.fs.dirname(file)
  local build = vim.fs.joinpath(root, 'build')
  vim.fn.mkdir(build, 'p')
  local output = vim.fs.joinpath(build, vim.fn.fnamemodify(file, ':t:r') .. executable_suffix)
  local standard = ft == 'cpp' and '-std=c++20' or '-std=c17'
  run_async('Compile', { compiler, standard, '-Wall', '-Wextra', '-g', file, '-o', output }, root, function()
    vim.b.devtools_binary = output
    if on_success then
      on_success(output)
    end
  end)
end

function M.build()
  if vim.fs.root(0, { 'CMakeLists.txt' }) then
    M.cmake_build()
  else
    single_file_build()
  end
end

function M.run()
  local file = vim.api.nvim_buf_get_name(0)
  local ft = vim.bo.filetype
  local root = project_root({ '.git', 'CMakeLists.txt', 'pyproject.toml', 'package.json', 'go.mod', 'Cargo.toml' })
  vim.cmd('silent write')

  if ft == 'python' then
    local python = first_executable(python_candidates)
    if python then terminal({ python, file }, root, 'Run Python') end
  elseif ft == 'javascript' or ft == 'javascriptreact' then
    if executable('node') then terminal({ 'node', file }, root, 'Run Node') end
  elseif ft == 'typescript' or ft == 'typescriptreact' then
    local runner = first_executable({ 'tsx', 'ts-node' })
    if runner then
      terminal({ runner, file }, root, 'Run TypeScript')
    else
      vim.notify('TypeScript cần tsx hoặc ts-node trong PATH', vim.log.levels.WARN)
    end
  elseif ft == 'go' then
    terminal(vim.uv.fs_stat(vim.fs.joinpath(root, 'go.mod')) and { 'go', 'run', '.' } or { 'go', 'run', file }, root, 'Run Go')
  elseif ft == 'rust' and vim.uv.fs_stat(vim.fs.joinpath(root, 'Cargo.toml')) then
    terminal({ 'cargo', 'run' }, root, 'Run Rust')
  elseif ft == 'java' and executable('java') then
    terminal({ 'java', file }, root, 'Run Java')
  elseif ft == 'sh' or ft == 'bash' then
    local shell = first_executable({ 'bash', 'sh' })
    if shell then terminal({ shell, file }, root, 'Run Shell') end
  elseif ft == 'lua' then
    local lua = first_executable({ 'lua', 'luajit' })
    if lua then terminal({ lua, file }, root, 'Run Lua') end
  elseif ft == 'c' or ft == 'cpp' then
    local binary = vim.b.devtools_binary
    if binary and vim.uv.fs_stat(binary) then
      terminal({ binary }, vim.fs.dirname(binary), 'Run C/C++')
    else
      single_file_build(function(output)
        terminal({ output }, vim.fs.dirname(output), 'Run C/C++')
      end)
    end
  else
    vim.notify('Chưa có runner mặc định cho filetype: ' .. ft, vim.log.levels.WARN)
  end
end

local formatters = {
  c = { { 'clang-format' } },
  cpp = { { 'clang-format' } },
  cuda = { { 'clang-format' } },
  python = { { 'ruff', 'format', '-' }, { 'black', '--quiet', '-' } },
  lua = { { 'stylua', '-' } },
  sh = { { 'shfmt' } },
  bash = { { 'shfmt' } },
  go = { { 'gofmt' } },
  rust = { { 'rustfmt', '--emit', 'stdout' } },
}

local prettier_filetypes = {
  javascript = true, javascriptreact = true, typescript = true,
  typescriptreact = true, json = true, jsonc = true, css = true,
  scss = true, html = true, yaml = true, markdown = true, svelte = true,
}

local function external_formatter(ft, filename)
  local candidates = formatters[ft] or {}
  if prettier_filetypes[ft] then
    candidates = { { 'prettier', '--stdin-filepath', filename } }
  end
  for _, command in ipairs(candidates) do
    if executable(command[1]) then
      return command
    end
  end
end

function M.format_buffer(bufnr, quiet)
  bufnr = bufnr or 0
  for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
    if client:supports_method('textDocument/formatting') then
      vim.lsp.buf.format({ bufnr = bufnr, async = false, id = client.id, timeout_ms = 5000 })
      return true
    end
  end

  local filename = vim.api.nvim_buf_get_name(bufnr)
  local command = external_formatter(vim.bo[bufnr].filetype, filename)
  if not command then
    if not quiet then
      vim.notify('Không có LSP hoặc formatter phù hợp cho buffer này', vim.log.levels.WARN)
    end
    return false
  end
  local input = table.concat(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false), '\n') .. '\n'
  local result = vim.system(command, { stdin = input, text = true }):wait(5000)
  if result.code ~= 0 then
    vim.notify((result.stderr or 'Formatter thất bại'):gsub('%s+$', ''), vim.log.levels.ERROR)
    return false
  end
  local view = vim.fn.winsaveview()
  local lines = vim.split((result.stdout or ''):gsub('\n$', ''), '\n', { plain = true })
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
  vim.fn.winrestview(view)
  return true
end

function M.health()
  local checks = {
    { 'Git', { 'git' } }, { 'Tìm kiếm', { 'rg' } }, { 'CMake', { 'cmake' } },
    { 'Build CMake', { 'ninja', 'make', 'mingw32-make' } },
    { 'C compiler', { vim.env.CC or '', 'gcc', 'clang', 'cl' } },
    { 'C++ compiler', { vim.env.CXX or '', 'g++', 'clang++', 'cl' } },
    { 'C/C++ LSP', { 'clangd' } }, { 'C/C++ debugger', { 'gdb', 'lldb' } },
    { 'Python', python_candidates }, { 'Node.js', { 'node' } },
    { 'Go', { 'go' } }, { 'Rust', { 'cargo', 'rustc' } }, { 'Java', { 'java', 'javac' } },
  }
  local lines = {
    'Neovim Developer Health',
    '========================',
    'Hệ điều hành: ' .. (is_windows and 'Windows' or vim.uv.os_uname().sysname),
    'Neovim: ' .. tostring(vim.version()),
    '',
  }
  for _, check in ipairs(checks) do
    local found = first_executable(check[2])
    table.insert(lines, string.format('%-18s %s', check[1] .. ':', found and ('OK (' .. found .. ')') or 'THIẾU'))
  end
  vim.cmd('botright new')
  vim.bo.buftype = 'nofile'
  vim.bo.bufhidden = 'wipe'
  vim.bo.swapfile = false
  vim.bo.filetype = 'checkhealth'
  vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
  vim.bo.modifiable = false
end

function M.setup()
  vim.g.autoformat_enabled = vim.g.autoformat_enabled == nil and 1 or vim.g.autoformat_enabled
  vim.api.nvim_create_user_command('Format', function() M.format_buffer(0) end, { desc = 'Format buffer bằng LSP hoặc formatter dự phòng' })
  vim.api.nvim_create_user_command('FormatToggle', function()
    vim.g.autoformat_enabled = vim.g.autoformat_enabled == 1 and 0 or 1
    vim.notify('Format on save: ' .. (vim.g.autoformat_enabled == 1 and 'ON' or 'OFF'))
  end, {})
  vim.api.nvim_create_user_command('Build', M.build, { desc = 'Build file hoặc project hiện tại' })
  vim.api.nvim_create_user_command('Run', M.run, { desc = 'Chạy file hiện tại' })
  vim.api.nvim_create_user_command('CMakeConfigure', M.cmake_configure, {})
  vim.api.nvim_create_user_command('CMakeBuild', M.cmake_build, {})
  vim.api.nvim_create_user_command('CMakeTest', M.cmake_test, {})
  vim.api.nvim_create_user_command('DevHealth', M.health, {})
  vim.keymap.set({ 'n', 'x' }, '<leader>f', function() M.format_buffer(0) end, { silent = true })
  vim.keymap.set('n', '<F9>', M.build, { silent = true, desc = 'Build' })
  vim.keymap.set('n', '<F10>', M.run, { silent = true, desc = 'Run' })
  local group = vim.api.nvim_create_augroup('user_autoformat', { clear = true })
  vim.api.nvim_create_autocmd('BufWritePre', {
    group = group,
    callback = function(args)
      if vim.g.autoformat_enabled == 1 and vim.bo[args.buf].buftype == '' then
        M.format_buffer(args.buf, true)
      end
    end,
  })
end

return M
