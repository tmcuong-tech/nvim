local dap = require "dap"
local dapui = require "dapui"

dapui.setup()

local function executable(name)
  local path = vim.fn.exepath(name)
  return path ~= "" and path or name
end

-- C / C++ / Rust - CodeLLDB
-- Register adapters before Mason finishes so they work immediately after install.
dap.adapters.codelldb = {
  type = "server",
  port = "${port}",
  executable = { command = executable "codelldb", args = { "--port", "${port}" } },
}

local codelldb_config = {
  {
    name = "Launch file",
    type = "codelldb",
    request = "launch",

    program = function()
      return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
    end,

    cwd = "${workspaceFolder}",
    stopOnEntry = false,
  },
}

dap.configurations.c = codelldb_config
dap.configurations.cpp = codelldb_config
dap.configurations.rust = codelldb_config

-- Python - debugpy
dap.adapters.python = { type = "executable", command = executable "debugpy-adapter" }

dap.configurations.python = {
  {
    type = "python",
    request = "launch",
    name = "Launch file",

    program = "${file}",

    pythonPath = function()
      local python = vim.fn.exepath "python3"
      return python ~= "" and python or vim.fn.exepath "python"
    end,

    console = "integratedTerminal",
  },
}

-- JavaScript / TypeScript - vscode-js-debug
dap.adapters["pwa-node"] = {
  type = "server",
  host = "127.0.0.1",
  port = "${port}",
  executable = { command = executable "js-debug-adapter", args = { "${port}" } },
}

local js_config = {
  {
    type = "pwa-node",
    request = "launch",
    name = "Launch current file",
    program = "${file}",
    cwd = "${workspaceFolder}",
    sourceMaps = true,
    console = "integratedTerminal",
  },
  {
    type = "pwa-node",
    request = "attach",
    name = "Attach to process",
    processId = require("dap.utils").pick_process,
    cwd = "${workspaceFolder}",
  },
}

for _, filetype in ipairs { "javascript", "javascriptreact", "typescript", "typescriptreact" } do
  dap.configurations[filetype] = js_config
end

-- PHP - Xdebug
dap.adapters.php = { type = "executable", command = executable "php-debug-adapter" }
dap.configurations.php = {
  { type = "php", request = "launch", name = "Listen for Xdebug", port = 9003 },
  { type = "php", request = "launch", name = "Launch current file", program = "${file}", cwd = "${fileDirname}" },
}

-- C# - netcoredbg
dap.adapters.coreclr = {
  type = "executable",
  command = executable "netcoredbg",
  args = { "--interpreter=vscode" },
}
dap.configurations.cs = {
  {
    type = "coreclr",
    name = "Launch .NET executable",
    request = "launch",
    program = function()
      return vim.fn.input("Path to dll/executable: ", vim.fn.getcwd() .. "/bin/Debug/", "file")
    end,
  },
}

-- Bash - bash-debug-adapter
dap.adapters.bashdb = { type = "executable", command = executable "bash-debug-adapter" }
dap.configurations.sh = {
  { type = "bashdb", request = "launch", name = "Launch file", program = "${file}", cwd = "${fileDirname}" },
}
dap.configurations.bash = dap.configurations.sh

-- Java configurations are generated per project by ftplugin/java.lua.

-- DAP UI
dap.listeners.before.attach.dapui_config = function()
  dapui.open()
end

dap.listeners.before.launch.dapui_config = function()
  dapui.open()
end

dap.listeners.before.event_terminated.dapui_config = function()
  dapui.close()
end

dap.listeners.before.event_exited.dapui_config = function()
  dapui.close()
end
