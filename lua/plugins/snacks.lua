return {
  {
    "folke/snacks.nvim",
    opts = {
      bigfile = {
        enabled = true,
      },

      dashboard = {
        enabled = true,
      },

      explorer = {
        enabled = true,
      },

      indent = {
        enabled = true,
      },

      input = {
        enabled = true,
      },

      notifier = {
        enabled = true,
        timeout = 3000,
      },

      picker = {
        enabled = true,
      },

      quickfile = {
        enabled = true,
      },

      scope = {
        enabled = true,
      },

      scroll = {
        enabled = true,
      },

      statuscolumn = {
        enabled = true,
      },

      terminal = {
        enabled = true,
      },

      words = {
        enabled = true,
      },

      zen = {
        enabled = true,
      },
    },

    keys = {
      {
        "<leader>ft",
        function()
          Snacks.terminal()
        end,
        desc = "Terminal",
      },

      {
        "<A-t>",
        function()
          Snacks.terminal()
        end,
        desc = "Floating Terminal",
      },

      {
        "<leader>fe",
        function()
          Snacks.explorer()
        end,
        desc = "File Explorer",
      },

      {
        "<leader>ff",
        function()
          Snacks.picker.files()
        end,
        desc = "Find Files",
      },

      {
        "<leader>fg",
        function()
          Snacks.picker.grep()
        end,
        desc = "Grep",
      },

      {
        "<leader>fb",
        function()
          Snacks.picker.buffers()
        end,
        desc = "Buffers",
      },

      {
        "<leader>fr",
        function()
          Snacks.picker.recent()
        end,
        desc = "Recent Files",
      },

      {
        "<leader>fz",
        function()
          Snacks.picker.zoxide()
        end,
        desc = "Zoxide",
      },

      {
        "<leader>fp",
        function()
          Snacks.picker.projects()
        end,
        desc = "Projects",
      },

      {
        "<leader>nh",
        function()
          Snacks.notifier.show_history()
        end,
        desc = "Notification History",
      },

      {
        "<leader>n",
        function()
          Snacks.notifier.hide()
        end,
        desc = "Dismiss Notifications",
      },

      {
        "<leader>uz",
        function()
          Snacks.zen()
        end,
        desc = "Zen Mode",
      },

      {
        "<leader>bd",
        function()
          Snacks.bufdelete()
        end,
        desc = "Delete Buffer",
      },

      {
        "<leader>gg",
        function()
          Snacks.lazygit()
        end,
        desc = "Lazygit",
      },

      {
        "<leader>gb",
        function()
          Snacks.git.blame_line()
        end,
        desc = "Git Blame Line",
      },
    },

    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          vim.keymap.set("n", "<leader>.", function()
            Snacks.scratch()
          end, { desc = "Scratch Buffer" })

          vim.keymap.set("n", "<leader>S", function()
            Snacks.scratch.select()
          end, { desc = "Select Scratch Buffer" })
        end,
      })
    end,
  },
}
