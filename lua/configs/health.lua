local M = {}

local groups = {
  LSP = {
    "lua-language-server",
    "clangd",
    "pyright-langserver",
    "typescript-language-server",
    "bash-language-server",
    "rust-analyzer",
    "gopls",
    "jdtls",
    "intelephense",
    "sql-language-server",
    "vscode-json-language-server",
    "yaml-language-server",
    "docker-langserver",
    "docker-compose-langserver",
    "lemminx",
    "cmake-language-server",
    "OmniSharp",
    "marksman",
    "markdown-oxide",
    "autotools-language-server",
  },
  Formatter = {
    "stylua",
    "clang-format",
    "ruff",
    "prettier",
    "shfmt",
    "rustfmt",
    "gofmt",
    "google-java-format",
    "yamlfmt",
    "asmfmt",
    "cmake-format",
    "php-cs-fixer",
    "csharpier",
    "sqlfluff",
    "xmlformat",
  },
  Linter = {
    "ruff",
    "eslint_d",
    "cpplint",
    "cmakelint",
    "yamllint",
    "markdownlint",
    "shellcheck",
    "hadolint",
    "sqlfluff",
  },
  Debugger = {
    "codelldb",
    "debugpy-adapter",
    "dlv",
    "js-debug-adapter",
    "php-debug-adapter",
    "netcoredbg",
    "bash-debug-adapter",
  },
}

function M.check()
  local lines = { "NvChad environment" }

  for _, group in ipairs { "LSP", "Formatter", "Linter", "Debugger" } do
    local executables = groups[group]
    table.insert(lines, "\n" .. group .. ":")
    for _, executable in ipairs(executables) do
      local installed = vim.fn.executable(executable) == 1
      table.insert(lines, ("  %s %s"):format(installed and "OK" or "--", executable))
    end
  end

  table.insert(lines, "\nMissing tools are optional and can be installed with :Mason.")
  vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO, { title = "Config health" })
end

vim.api.nvim_create_user_command("ConfigHealth", M.check, {
  desc = "Check external tools used by this configuration",
})

return M
