" Native LSP owns Assembly, Lua and Go.
" Python and TypeScript stay in Coc to avoid duplicate pyright/ts_ls clients.
if has('nvim-0.11')
  lua << EOF
  local mason_ok, mason = pcall(require, 'mason')
  if mason_ok then
    mason.setup()
  end

  local ensure_installed = { 'lua_ls' }
  if vim.fn.executable('go') == 1 or vim.fn.executable('gopls') == 1 then
    table.insert(ensure_installed, 'gopls')
  end

  -- asm-lsp builds from source. Let Mason install it automatically only on
  -- Unix-like systems with Cargo; Windows users can install a GNU build as
  -- documented in README.md. Missing optional toolchains never break startup.
  if vim.fn.has('win32') == 0
      and vim.fn.executable('cargo') == 1
      and vim.fn.executable('asm-lsp') == 0 then
    table.insert(ensure_installed, 'asm_lsp')
  end

  local mason_lsp_ok, mason_lsp = pcall(require, 'mason-lspconfig')
  if mason_lsp_ok then
    mason_lsp.setup({
      ensure_installed = ensure_installed,
      automatic_enable = ensure_installed,
    })
  end

  if vim.fn.executable('asm-lsp') == 1 then
    vim.lsp.config('asm_lsp', {
      cmd = { 'asm-lsp' },
      filetypes = { 'asm', 'vmasm' },
    })
    vim.lsp.enable('asm_lsp')
  end

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

  if vim.fn.executable('lua-language-server') == 1 then
    vim.lsp.enable('lua_ls')
  end

  vim.lsp.config('gopls', {
    filetypes = { 'go', 'gomod', 'gowork' },
  })

  if vim.fn.executable('gopls') == 1 then
    vim.lsp.enable('gopls')
  end

  local lsp_attach_group = vim.api.nvim_create_augroup('user_native_lsp_attach', { clear = true })
  local lsp_format_group = vim.api.nvim_create_augroup('user_native_lsp_format', { clear = true })

  vim.api.nvim_create_autocmd('LspAttach', {
    group = lsp_attach_group,
    callback = function(args)
      local bufnr = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if not client then
        return
      end

      local opts = { buffer = bufnr, silent = true }
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
      vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
      vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
      vim.keymap.set({ 'n', 'x' }, '<leader>f', function()
        vim.lsp.buf.format({ bufnr = bufnr, async = true, id = client.id })
      end, opts)

      if client:supports_method('textDocument/completion') then
        vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })
      end

      vim.api.nvim_clear_autocmds({ group = lsp_format_group, buffer = bufnr })
      if client:supports_method('textDocument/formatting') then
        vim.api.nvim_create_autocmd('BufWritePre', {
          group = lsp_format_group,
          buffer = bufnr,
          callback = function()
            vim.lsp.buf.format({
              bufnr = bufnr,
              async = false,
              id = client.id,
              timeout_ms = 3000,
            })
          end,
        })
      end
    end,
  })

  -- When Neovim starts with a file argument, its FileType event can occur
  -- before this config file is sourced. Replay only the native-LSP handler.
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
