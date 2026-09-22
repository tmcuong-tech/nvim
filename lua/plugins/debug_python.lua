return {
  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    dependencies = {
      "mfussenegger/nvim-dap",
    },
    config = function()
      local is_windows = vim.fn.has("win32") == 1
      local cwd = vim.fn.getcwd()

      -- 1. Ưu tiên tìm Python trong virtualenv của project (.venv hoặc venv)
      local venv_paths = is_windows
          and { cwd .. "\\.venv\\Scripts\\python.exe", cwd .. "\\venv\\Scripts\\python.exe" }
        or { cwd .. "/.venv/bin/python", cwd .. "/venv/bin/python" }

      local python_path = nil
      for _, path in ipairs(venv_paths) do
        if vim.fn.filereadable(path) == 1 then
          python_path = path
          break
        end
      end

      -- 2. Nếu không có virtualenv, tìm debugpy trong Mason
      if not python_path then
        local ok, mason_registry = pcall(require, "mason-registry")
        if ok and mason_registry.is_installed("debugpy") then
          local pkg = mason_registry.get_package("debugpy")
          local install_path = pkg:get_install_path()
          local mason_python = is_windows and (install_path .. "\\venv\\Scripts\\python.exe")
            or (install_path .. "/venv/bin/python")
          if vim.fn.filereadable(mason_python) == 1 then
            python_path = mason_python
          end
        end
      end

      -- 3. Fallback cuối cùng: python hệ thống
      if not python_path then
        python_path = vim.fn.exepath("python3")
        if python_path == "" then
          python_path = vim.fn.exepath("python")
        end
      end

      require("dap-python").setup(python_path)
    end,
  },
}
