require("nvchad.configs.lspconfig").defaults()

local servers = {
  -- HTML
  "html",

  -- CSS
  "cssls",

  -- JavaScript / TypeScript
  "ts_ls",

  -- PYTHON
  "pyright",

  -- C / C++
  "clangd",

  -- ASSEMBLY
  -- "asm_lsp", -- đang Failed trong Mason

  -- BASH / SHELL
  "bashls",

  -- RUST
  "rust_analyzer",

  -- GO
  "gopls",

  -- JAVA
  -- jdtls is started by ftplugin/java.lua so its debugger can share the same client.

  -- PHP
  "intelephense",

  -- SQL
  "sqlls",

  -- LUA
  "lua_ls",

  -- JSON
  "jsonls",

  -- YAML
  "yamlls",

  -- DOCKER
  "dockerls",
  "docker_compose_language_service",

  -- XML
  "lemminx",

  -- CMAKE
  "cmake",

  -- C#
  "omnisharp",

  -- MARKDOWN (use one server to avoid duplicate diagnostics/completion)
  "markdown_oxide",

  -- AUTOTOOLS
  "autotools_ls",
}

vim.lsp.enable(servers)

-- read :h vim.lsp.config for changing options of lsp servers
