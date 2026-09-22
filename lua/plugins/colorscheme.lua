return {
  -- 1. Gruvbox
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    opts = {
      transparent_mode = false,
    },
  },

  -- 2. Tokyo Night
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    opts = {
      style = "night", -- Các tùy chọn: "night", "storm", "moon", "day"
      transparent = false,
      styles = {
        sidebars = "dark",
        floats = "dark",
      },
    },
  },

  -- 3. One Dark
  {
    "navarasu/onedark.nvim",
    priority = 1000,
    opts = {
      style = "dark", -- Các tùy chọn: "dark", "darker", "cool", "deep", "warm", "warmer", "light"
      transparent = false,
    },
  },

  -- 4. Catppuccin
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      flavour = "mocha", -- Các tùy chọn: "mocha", "macchiato", "frappe", "latte"
      transparent_background = false,
      integrations = {
        blink_cmp = true,
        gitsigns = true,
        snacks = true,
        treesitter = true,
        which_key = true,
      },
    },
  },

  -- Thiết lập colorscheme hoạt động cho LazyVim
  {
    "LazyVim/LazyVim",
    opts = {
      -- Đổi tên theme bạn muốn dùng mặc định tại đây:
      -- "gruvbox" | "tokyonight" | "onedark" | "catppuccin" | "catppuccin-mocha" | "catppuccin-macchiato"
      colorscheme = "gruvbox",
    },
  },
}

