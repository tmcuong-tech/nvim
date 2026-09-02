local jdtls = require "jdtls"

local command = vim.fn.exepath "jdtls"
if command == "" then
  vim.schedule(function()
    vim.notify("jdtls is not installed yet; open :Mason to install it", vim.log.levels.WARN)
  end)
  return
end

local filename = vim.api.nvim_buf_get_name(0)
local fallback_root = filename ~= "" and vim.fs.dirname(filename) or vim.uv.cwd()
local root = vim.fs.root(0, { "gradlew", "mvnw", ".git", "pom.xml", "build.gradle", "settings.gradle" })
  or fallback_root
  or vim.uv.cwd()
local project = vim.fn.fnamemodify(root, ":t")
if project == "" then
  project = "java-project"
end
local workspace = vim.fn.stdpath "cache" .. "/jdtls/" .. project .. "-" .. vim.fn.sha256(root):sub(1, 12)
local packages = vim.fn.stdpath "data" .. "/mason/packages"

local bundles =
  vim.fn.glob(packages .. "/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar", true, true)
vim.list_extend(bundles, vim.fn.glob(packages .. "/java-test/extension/server/*.jar", true, true))

jdtls.start_or_attach {
  cmd = { command, "-data", workspace },
  root_dir = root,
  init_options = { bundles = bundles },
  on_attach = function(client, bufnr)
    require("nvchad.configs.lspconfig").on_attach(client, bufnr)
    jdtls.setup_dap { hotcodereplace = "auto" }
  end,
  capabilities = require("nvchad.configs.lspconfig").capabilities,
}
