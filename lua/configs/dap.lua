local dap = require "dap"
local dapui = require "dapui"

dapui.setup()

-- ========================================
-- C / C++ / Rust - CodeLLDB
-- ========================================

if vim.fn.executable "codelldb" == 1 then
  dap.adapters.codelldb = {
    type = "server",
    port = "${port}",
    executable = { command = "codelldb", args = { "--port", "${port}" } },
  }
end

local codelldb_config = {
  {
    name = "Launch file",
    type = "codelldb",
    request = "launch",

    program = function()
      return vim.fn.input(
        "Path to executable: ",
        vim.fn.getcwd() .. "/",
        "file"
      )
    end,

    cwd = "${workspaceFolder}",
    stopOnEntry = false,
  },
}

if dap.adapters.codelldb then
  dap.configurations.c = codelldb_config
  dap.configurations.cpp = codelldb_config
  dap.configurations.rust = codelldb_config
end


-- ========================================
-- Python - debugpy
-- ========================================

if vim.fn.executable "debugpy-adapter" == 1 then
  dap.adapters.python = { type = "executable", command = "debugpy-adapter" }
end

if dap.adapters.python then
  dap.configurations.python = {
  {
    type = "python",
    request = "launch",
    name = "Launch file",

    program = "${file}",

    pythonPath = function()
      return vim.fn.exepath("python")
    end,

    console = "integratedTerminal",
  },
  }
end


-- ========================================
-- DAP UI
-- ========================================

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


-- ========================================
-- Keymaps
-- ========================================

vim.keymap.set("n", "<F5>", dap.continue, {
  desc = "Debug: Continue",
})

vim.keymap.set("n", "<F10>", dap.step_over, {
  desc = "Debug: Step Over",
})

vim.keymap.set("n", "<F11>", dap.step_into, {
  desc = "Debug: Step Into",
})

vim.keymap.set("n", "<F12>", dap.step_out, {
  desc = "Debug: Step Out",
})

vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, {
  desc = "Debug: Toggle Breakpoint",
})

vim.keymap.set("n", "<leader>dB", function()
  dap.set_breakpoint(
    vim.fn.input("Breakpoint condition: ")
  )
end, {
  desc = "Debug: Conditional Breakpoint",
})

vim.keymap.set("n", "<leader>du", dapui.toggle, {
  desc = "Debug: Toggle UI",
})
