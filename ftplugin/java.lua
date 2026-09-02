local jdtls = require "jdtls"

local root = vim.fs.root(0, { "gradlew", "mvnw", ".git", "pom.xml", "build.gradle", "settings.gradle" })
  or vim.fs.dirname(vim.api.nvim_buf_get_name(0))
local project = vim.fn.fnamemodify(root, ":t")
local workspace = vim.fn.stdpath "cache" .. "/jdtls/" .. project
local packages = vim.fn.stdpath "data" .. "/mason/packages"

local bundles =
  vim.fn.glob(packages .. "/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar", true, true)
vim.list_extend(bundles, vim.fn.glob(packages .. "/java-test/extension/server/*.jar", true, true))

jdtls.start_or_attach {
  cmd = { "jdtls", "-data", workspace },
  root_dir = root,
  init_options = { bundles = bundles },
  on_attach = function(client, bufnr)
    require("nvchad.configs.lspconfig").on_attach(client, bufnr)
    jdtls.setup_dap { hotcodereplace = "auto" }
  end,
  capabilities = require("nvchad.configs.lspconfig").capabilities,
}
