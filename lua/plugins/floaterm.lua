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

      -- Tương thích shell đa nền tảng:
      -- Trên Windows: ưu tiên PowerShell 7 (pwsh) nếu có, fallback sang powershell mặc định
      -- Trên Linux: dùng $SHELL (bash, zsh, fish)
      if vim.fn.has("win32") == 1 then
        if vim.fn.executable("pwsh") == 1 then
          vim.g.floaterm_shell = "pwsh -NoLogo"
        else
          vim.g.floaterm_shell = "powershell -NoLogo"
        end
      else
        vim.g.floaterm_shell = vim.o.shell ~= "" and vim.o.shell or (os.getenv("SHELL") or "/bin/bash")
      end
    end,
    config = function()
      -- Thích ứng màu sắc viền và nền terminal nổi theo theme đang chọn
      vim.api.nvim_set_hl(0, "Floaterm", { link = "NormalFloat" })
      vim.api.nvim_set_hl(0, "FloatermBorder", { link = "FloatBorder" })

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

