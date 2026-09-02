local ok, lazy = pcall(require, "lazy")
if not ok then
  local config = vim.fn.stdpath "config"
  vim.go.loadplugins = true
  vim.opt.runtimepath:prepend(config)
  dofile(config .. "/init.lua")
  ok, lazy = pcall(require, "lazy")
end
assert(ok, "lazy.nvim did not load")

lazy.load {
  plugins = {
    "conform.nvim",
    "mason.nvim",
    "mason-tool-installer.nvim",
    "nvim-dap",
    "nvim-dap-ui",
    "nvim-jdtls",
    "nvim-lint",
    "neotest",
  },
}

vim.wait(1000)

for _, module in ipairs { "conform", "dap", "dapui", "lint", "neotest" } do
  assert(pcall(require, module), ("module %s did not load"):format(module))
end

local dap = require "dap"
for _, filetype in ipairs { "c", "cpp", "rust", "python", "go", "javascript", "typescript", "php", "cs", "bash" } do
  assert(dap.configurations[filetype], ("DAP has no configuration for %s"):format(filetype))
end

assert(vim.fn.exists ":ConfigHealth" == 2, ":ConfigHealth was not registered")
print(("SMOKE_OK plugins=%d"):format(lazy.stats().count))
vim.cmd "qa"
