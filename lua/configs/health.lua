local M = {}

local groups = {
  LSP = {
    "lua-language-server",
    "clangd",
    "pyright-langserver",
    "typescript-language-server",
    "bash-language-server",
  },
  Formatter = { "stylua", "clang-format", "ruff", "prettier", "shfmt" },
  Debugger = { "codelldb", "debugpy-adapter" },
}

function M.check()
  local lines = { "NvChad environment" }

  for group, executables in pairs(groups) do
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
