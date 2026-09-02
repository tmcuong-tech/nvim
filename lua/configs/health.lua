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

local order = { "LSP", "Formatter", "Linter", "Debugger" }

local function status_lines()
  local lines = { "NvChad environment" }

  for _, group in ipairs(order) do
    local executables = groups[group]
    table.insert(lines, "\n" .. group .. ":")
    for _, executable in ipairs(executables) do
      local installed = vim.fn.executable(executable) == 1
      table.insert(lines, ("  %s %s"):format(installed and "OK" or "--", executable))
    end
  end

  table.insert(lines, "\nMissing tools are optional and can be installed with :Mason.")
  return lines
end

-- Entry point discovered by :checkhealth configs.
function M.check()
  vim.health.start "External development tools"

  for _, group in ipairs(order) do
    local missing = {}
    for _, executable in ipairs(groups[group]) do
      if vim.fn.executable(executable) == 0 then
        table.insert(missing, executable)
      end
    end

    if #missing == 0 then
      vim.health.ok(group .. ": all configured tools are available")
    else
      vim.health.warn(group .. ": missing " .. table.concat(missing, ", "), {
        "Open :Mason and wait for pending installations to finish.",
        "Install the matching language runtime when Mason reports a runtime dependency.",
      })
    end
  end
end

function M.show()
  local lines = status_lines()
  vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO, { title = "Config health" })
end

vim.api.nvim_create_user_command("ConfigHealth", M.show, {
  desc = "Check external tools used by this configuration",
})

return M
