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
  Runtime = {
    "node",
    "python",
    "go",
    "cargo",
    "java",
    "javac",
    "dotnet-sdk",
    "php",
    "c-compiler",
    "shell",
  },
  Host = {
    "git",
    "rg",
    "download-tool",
  },
}

local order = { "LSP", "Formatter", "Linter", "Debugger", "Runtime", "Host" }

local alternatives = {
  python = { "python3", "python" },
  ["c-compiler"] = { "cc", "gcc", "clang", "cl" },
  shell = { "bash", "sh" },
  ["download-tool"] = { "curl", "wget" },
}

local function executable_available(executable)
  if alternatives[executable] then
    return vim.iter(alternatives[executable]):any(function(command)
      return vim.fn.executable(command) == 1
    end)
  end

  if executable ~= "dotnet-sdk" then
    return vim.fn.executable(executable) == 1
  end

  if vim.fn.executable "dotnet" == 0 then
    return false
  end

  local output = vim.fn.systemlist { "dotnet", "--list-sdks" }
  return vim.v.shell_error == 0 and #output > 0
end

local function advice_for(group)
  if group == "Runtime" then
    return {
      "Install only the language runtimes/SDKs needed by your projects.",
      "Mason manages editor tooling, not language runtimes.",
    }
  end

  if group == "Host" then
    return { "Install the missing host command with your operating-system package manager." }
  end

  return { "Open :Mason and wait for pending installations to finish." }
end

local function status_lines()
  local lines = { "NvChad environment" }

  for _, group in ipairs(order) do
    local executables = groups[group]
    table.insert(lines, "\n" .. group .. ":")
    for _, executable in ipairs(executables) do
      local installed = executable_available(executable)
      table.insert(lines, ("  %s %s"):format(installed and "OK" or "--", executable))
    end
  end

  table.insert(lines, "\nInstall editor tools with :Mason and host runtimes/SDKs with the operating system.")
  return lines
end

-- Entry point discovered by :checkhealth configs.
function M.check()
  vim.health.start "External development tools"

  for _, group in ipairs(order) do
    local missing = {}
    for _, executable in ipairs(groups[group]) do
      if not executable_available(executable) then
        table.insert(missing, executable)
      end
    end

    if #missing == 0 then
      vim.health.ok(group .. ": all configured tools are available")
    else
      vim.health.warn(group .. ": missing " .. table.concat(missing, ", "), advice_for(group))
    end
  end
end

function M.show()
  local lines = status_lines()
  vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO, { title = "Config health" })
end

local validation_modules = {
  "aerial",
  "conform",
  "dap",
  "dapui",
  "diffview",
  "lint",
  "neogit",
  "neotest",
  "overseer",
  "persistence",
  "spectre",
  "todo-comments",
  "trouble",
}

local validation_commands = {
  "AerialToggle",
  "DiffviewOpen",
  "Neogit",
  "OverseerRun",
  "Spectre",
  "Trouble",
}

local function validate_lua_syntax()
  local root = vim.fn.stdpath "config"
  for name, filetype in vim.fs.dir(root, { depth = 4 }) do
    if filetype == "file" and name:match "%.lua$" then
      local _, error_message = loadfile(root .. "/" .. name)
      assert(not error_message, ("invalid Lua file %s: %s"):format(name, error_message))
    end
  end
end

function M.validate()
  local lazy = require "lazy"
  local lazy_config = require "lazy.core.config"

  validate_lua_syntax()
  lazy.load { plugins = vim.tbl_keys(lazy_config.plugins) }
  assert(
    not lazy_config.spec or vim.tbl_isempty(lazy_config.spec.errors or {}),
    "lazy.nvim reported plugin spec errors"
  )

  for _, module in ipairs(validation_modules) do
    local ok, result = pcall(require, module)
    assert(ok, ("module %s did not load: %s"):format(module, result))
  end

  local dap = require "dap"
  for _, filetype in ipairs { "c", "cpp", "rust", "python", "go", "javascript", "typescript", "php", "cs", "bash" } do
    assert(dap.configurations[filetype], ("DAP has no configuration for %s"):format(filetype))
  end

  for _, command in ipairs(validation_commands) do
    assert(vim.fn.exists(":" .. command) == 2, ("command %s was not registered"):format(command))
  end

  assert(vim.fn.exists "#IdeExperience#TextYankPost" == 1, "IDE autocmds were not registered")
  assert(vim.fn.exists "#NvimLint#BufReadPost" == 1, "lint autocmds were not registered")
  print(("CONFIG_OK plugins=%d"):format(lazy.stats().count))
end

vim.api.nvim_create_user_command("ConfigHealth", M.show, {
  desc = "Check external tools used by this configuration",
  force = true,
})

vim.api.nvim_create_user_command("ConfigValidate", M.validate, {
  desc = "Load and validate all configured plugins",
  force = true,
})

return M
