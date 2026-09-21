return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
    },

    keys = {
      {
        "<leader>tt",
        function()
          require("neotest").run.run()
        end,
        desc = "Test: Run Nearest",
      },

      {
        "<leader>tf",
        function()
          require("neotest").run.run(vim.fn.expand("%"))
        end,
        desc = "Test: Run File",
      },

      {
        "<leader>to",
        function()
          require("neotest").output.open()
        end,
        desc = "Test: Output",
      },

      {
        "<leader>ts",
        function()
          require("neotest").summary.toggle()
        end,
        desc = "Test: Summary",
      },
    },

    config = function()
      require("neotest").setup({})
    end,
  },
}
