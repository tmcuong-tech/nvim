return {
  {
    "voldikss/vim-floaterm",

    cmd = {
      "FloatermNew",
      "FloatermToggle",
      "FloatermKill",
      "FloatermNext",
      "FloatermPrev",
    },

    keys = {
      {
        "<leader>zo",
        "<cmd>FloatermNew<cr>",
        desc = "Floaterm New",
      },
      {
        "<leader>zk",
        "<cmd>FloatermKill<cr>",
        desc = "Floaterm Kill",
      },
      {
        "<leader>zn",
        "<cmd>FloatermNext<cr>",
        desc = "Floaterm Next",
      },
      {
        "<leader>zp",
        "<cmd>FloatermPrev<cr>",
        desc = "Floaterm Previous",
      },
      {
        "<leader>zt",
        "<cmd>FloatermToggle<cr>",
        desc = "Floaterm Toggle",
      },
    },

    init = function()
      vim.g.floaterm_position = "topright"
      vim.g.floaterm_width = 0.4
      vim.g.floaterm_height = 0.4
      vim.g.floaterm_wintype = "float"

      vim.g.floaterm_title = " Terminal $1/$2 "
      vim.g.floaterm_titleposition = "center"

      vim.g.floaterm_autoclose = "smart"
      vim.g.floaterm_autoinsert = "smart"
      vim.g.floaterm_autohide = "smart"

      vim.g.floaterm_borderchars = {
        "─",
        "│",
        "─",
        "│",
        "╭",
        "╮",
        "╯",
        "╰",
      }

      vim.g.floaterm_rootmarkers = {
        ".git",
        ".project",
        ".hg",
        ".svn",
        ".root",
        "Makefile",
        "CMakeLists.txt",
        ".pro",
      }

      vim.g.floaterm_giteditor = true

      if vim.fn.has("win32") == 1 then
        vim.g.floaterm_shell = "powershell -NoLogo"
      else
        vim.g.floaterm_shell = vim.o.shell
      end
    end,

    config = function()
      vim.api.nvim_set_hl(0, "Floaterm", {
        bg = "#282828",
      })

      vim.api.nvim_set_hl(0, "FloatermBorder", {
        fg = "#d79921",
        bg = "#1d2021",
      })

      vim.api.nvim_set_hl(0, "FloatermNC", {
        bg = "#1d2021",
      })

      vim.api.nvim_create_autocmd("User", {
        pattern = "FloatermOpen",
        callback = function()
          vim.opt_local.number = false
          vim.opt_local.relativenumber = false
          vim.opt_local.signcolumn = "no"
        end,
      })
    end,
  },
}
