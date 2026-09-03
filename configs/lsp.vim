" All language intelligence is provided by Neovim's native LSP client.
if has('nvim-0.11')
  lua << EOF
  -- Save executables from the user's PATH before Mason prepends its own bin
  -- directory. A system clangd installed beside clang/clang++ is usually the
  -- most coherent choice; Mason remains the portable fallback.
  local system_clangd = vim.fn.exepath('clangd')
  local cpp_drivers = {}
  for _, executable in ipairs({ 'clang++', 'g++', 'clang', 'gcc', 'cl' }) do
    local path = vim.fn.exepath(executable)
    if path ~= '' then
      table.insert(cpp_drivers, (path:gsub('\\', '/')))
    end
  end

  -- A standalone LLVM installation on Windows does not contain the C++
  -- standard library. For loose files (which have no compile_commands.json),
  -- reuse the include search path and target reported by an installed MinGW
  -- g++. Real projects still get their exact flags from the compilation DB.
  local clangd_fallback_flags = { '-std=c++20' }
  if vim.fn.has('win32') == 1 and vim.fn.executable('g++') == 1 then
    local probe_ok, probe = pcall(function()
      return vim.system({ vim.fn.exepath('g++'), '-E', '-x', 'c++', '-', '-v' }, {
        stdin = '',
        text = true,
      }):wait(5000)
    end)
    if probe_ok and probe then
      local compiler_info = (probe.stdout or '') .. '\n' .. (probe.stderr or '')
      local target = compiler_info:match('Target:%s*([^%s]+)')
      if target then
        table.insert(clangd_fallback_flags, '--target=' .. target)
      end
      local in_search_list = false
      for line in compiler_info:gmatch('[^\r\n]+') do
        if line:find('#include <%.%.%.> search starts here:', 1, false) then
          in_search_list = true
        elseif in_search_list and line:find('End of search list%.') then
          break
        elseif in_search_list then
          local include = vim.trim(line)
          if include ~= '' and vim.fn.isdirectory(include) == 1 then
            table.insert(clangd_fallback_flags, '-isystem')
            table.insert(clangd_fallback_flags, (include:gsub('\\', '/')))
          end
        end
      end
    end
  end

  local mason_ok, mason = pcall(require, 'mason')
  if mason_ok then
    mason.setup()
  end

  vim.opt.completeopt = { 'menu', 'menuone', 'noselect', 'popup' }

  vim.diagnostic.config({
    signs = false,
    underline = true,
    update_in_insert = true,
    severity_sort = true,
    virtual_text = {
      prefix = '■',
      spacing = 2,
      source = 'if_many',
    },
    float = {
      border = 'rounded',
      source = true,
    },
  })

  -- Names are nvim-lspconfig identifiers. mason-lspconfig translates them to
  -- the matching Mason packages on Windows, Linux and macOS.
  local servers = {
    'bashls',
    'clangd',
    'cmake',
    'cssls',
    'gopls',
    'html',
    'jdtls',
    'jsonls',
    'lua_ls',
    'pyright',
    'rust_analyzer',
    'svelte',
    'ts_ls',
    'vimls',
    'yamlls',
  }

  local ensure_installed = vim.deepcopy(servers)

  -- asm-lsp builds from source. Mason can install it automatically on Unix
  -- when Cargo exists. On Windows, enable an existing executable; README.md
  -- documents a GNU-toolchain installation that does not require MSVC.
  if vim.fn.has('win32') == 0 and vim.fn.executable('cargo') == 1 then
    table.insert(ensure_installed, 'asm_lsp')
  end
  if vim.fn.executable('asm-lsp') == 1 then
    table.insert(servers, 'asm_lsp')
  end

  -- Language-specific settings shared by every supported platform.
  local clangd_cmd = {
      system_clangd ~= '' and system_clangd or 'clangd',
      '--background-index',
      '--clang-tidy',
      '--completion-style=detailed',
      '--header-insertion=iwyu',
  }
  if #cpp_drivers > 0 then
    table.insert(clangd_cmd, '--query-driver=' .. table.concat(cpp_drivers, ','))
  end

  vim.lsp.config('clangd', {
    cmd = clangd_cmd,
    filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda' },
    init_options = {
      fallbackFlags = clangd_fallback_flags,
    },
  })

  vim.lsp.config('gopls', {
    filetypes = { 'go', 'gomod', 'gowork' },
  })

  vim.lsp.config('pyright', {
    settings = {
      python = {
        analysis = {
          autoImportCompletions = true,
          diagnosticMode = 'openFilesOnly',
          typeCheckingMode = 'standard',
          useLibraryCodeForTypes = true,
        },
      },
    },
  })

  vim.lsp.config('rust_analyzer', {
    settings = {
      ['rust-analyzer'] = {
        check = { command = 'check' },
      },
    },
  })

  vim.lsp.config('yamlls', {
    filetypes = { 'yaml' },
    settings = {
      redhat = { telemetry = { enabled = false } },
      yaml = {
        completion = true,
        format = { enable = true },
        validate = true,
      },
    },
  })

  vim.lsp.config('lua_ls', {
    settings = {
      Lua = {
        runtime = { version = 'LuaJIT' },
        diagnostics = { globals = { 'vim' } },
        workspace = {
          checkThirdParty = false,
          library = { vim.env.VIMRUNTIME },
        },
      },
    },
  })

  vim.lsp.config('asm_lsp', {
    cmd = { 'asm-lsp' },
    filetypes = { 'asm', 'vmasm' },
  })

  local lsp_attach_group = vim.api.nvim_create_augroup('user_lsp_attach', { clear = true })
  local lsp_completion_group = vim.api.nvim_create_augroup('user_lsp_completion', { clear = true })
  local lsp_highlight_group = vim.api.nvim_create_augroup('user_lsp_highlight', { clear = true })

  vim.api.nvim_create_autocmd('LspAttach', {
    group = lsp_attach_group,
    callback = function(args)
      local bufnr = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if not client then
        return
      end

      local opts = { buffer = bufnr, silent = true }
      vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
      vim.keymap.set('n', 'gy', vim.lsp.buf.type_definition, opts)
      vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
      vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
      vim.keymap.set('i', '<C-k>', vim.lsp.buf.signature_help, opts)
      vim.keymap.set('n', '[g', function()
        vim.diagnostic.jump({ count = -1, float = true })
      end, opts)
      vim.keymap.set('n', ']g', function()
        vim.diagnostic.jump({ count = 1, float = true })
      end, opts)
      vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
      vim.keymap.set('n', '<leader>ld', vim.diagnostic.setloclist, opts)
      vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
      vim.keymap.set({ 'n', 'x' }, '<leader>aa', vim.lsp.buf.code_action, opts)
      vim.keymap.set('n', '<leader>lo', vim.lsp.buf.document_symbol, opts)
      vim.keymap.set('n', '<leader>ls', vim.lsp.buf.workspace_symbol, opts)
      vim.keymap.set({ 'n', 'x' }, '<leader>f', function()
        require('user.devtools').format_buffer(bufnr)
      end, opts)

      if client:supports_method('textDocument/completion') then
        vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })

        -- Native autotrigger only reacts to server-defined characters such as
        -- `.` or `:`. Request completion before every inserted character so
        -- ordinary identifiers also produce suggestions while typing.
        vim.api.nvim_clear_autocmds({ group = lsp_completion_group, buffer = bufnr })
        vim.api.nvim_create_autocmd('InsertCharPre', {
          group = lsp_completion_group,
          buffer = bufnr,
          callback = function()
            vim.lsp.completion.get()
          end,
        })

        local completion_opts = {
          buffer = bufnr,
          expr = true,
          silent = true,
          replace_keycodes = true,
        }
        vim.keymap.set('i', '<Tab>', function()
          return vim.fn.pumvisible() == 1 and '<C-n>' or '<Tab>'
        end, completion_opts)
        vim.keymap.set('i', '<S-Tab>', function()
          return vim.fn.pumvisible() == 1 and '<C-p>' or '<S-Tab>'
        end, completion_opts)
        vim.keymap.set('i', '<CR>', function()
          local info = vim.fn.complete_info({ 'selected' })
          return vim.fn.pumvisible() == 1 and info.selected >= 0 and '<C-y>' or '<CR>'
        end, completion_opts)
        vim.keymap.set('i', '<C-Space>', vim.lsp.completion.get, opts)
        if vim.fn.has('win32') == 1 then
          vim.keymap.set('i', '<C-@>', vim.lsp.completion.get, opts)
        end
      end

      if client:supports_method('textDocument/documentHighlight') then
        vim.api.nvim_clear_autocmds({ group = lsp_highlight_group, buffer = bufnr })
        vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
          group = lsp_highlight_group,
          buffer = bufnr,
          callback = vim.lsp.buf.document_highlight,
        })
        vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
          group = lsp_highlight_group,
          buffer = bufnr,
          callback = vim.lsp.buf.clear_references,
        })
      end

    end,
  })

  -- Register mappings/autocommands before enabling configs so a file passed on
  -- the command line cannot attach before its buffer-local behavior exists.
  local mason_lsp_ok, mason_lsp = pcall(require, 'mason-lspconfig')
  if mason_lsp_ok then
    mason_lsp.setup({
      ensure_installed = ensure_installed,
      automatic_enable = false,
    })
  end

  -- Enable configs independently of Mason so servers installed through a
  -- system package manager also work. Missing executables do not affect
  -- startup; Mason installs the configured set in the background.
  vim.lsp.enable(servers)

  -- A file passed on the command line can receive FileType before this file is
  -- sourced. Replay Neovim's native activation handler for that buffer only.
  vim.schedule(function()
    if vim.bo.filetype ~= '' then
      pcall(vim.api.nvim_exec_autocmds, 'FileType', {
        group = 'nvim.lsp.enable',
        buffer = 0,
        modeline = false,
      })
    end
  end)
EOF
endif
