return {
  {
    "mfussenegger/nvim-dap-python",
    ft = "python",

    dependencies = {
      "mfussenegger/nvim-dap",
    },

    config = function()
      local path = vim.fn.exepath("python")

      require("dap-python").setup(path)
    end,
  },
}
