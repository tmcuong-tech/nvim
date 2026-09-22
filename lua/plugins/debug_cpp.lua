return {
  {
    "mfussenegger/nvim-dap",
    opts = function()
      local dap = require("dap")
      local is_windows = vim.fn.has("win32") == 1

      if not dap.adapters.codelldb then
        local codelldb_cmd = "codelldb"
        local ok, mason_registry = pcall(require, "mason-registry")
        if ok and mason_registry.is_installed("codelldb") then
          local pkg = mason_registry.get_package("codelldb")
          local install_path = pkg:get_install_path()
          if is_windows then
            codelldb_cmd = install_path .. "\\extension\\adapter\\codelldb.exe"
          else
            codelldb_cmd = install_path .. "/extension/adapter/codelldb"
          end
        end

        dap.adapters.codelldb = {
          type = "server",
          port = "${port}",
          executable = {
            command = codelldb_cmd,
            args = { "--port", "${port}" },
          },
        }
      end

      local get_executable = function()
        local default = vim.fn.getcwd() .. (is_windows and "\\" or "/")
        local path = vim.fn.input("Đường dẫn file thực thi: ", default, "file")
        return (path and path ~= "") and path or dap.ABORT
      end

      dap.configurations.cpp = dap.configurations.cpp or {}
      table.insert(dap.configurations.cpp, {
        name = "Launch C++ (codelldb)",
        type = "codelldb",
        request = "launch",
        program = get_executable,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
      })

      dap.configurations.c = dap.configurations.cpp
    end,
  },
}
