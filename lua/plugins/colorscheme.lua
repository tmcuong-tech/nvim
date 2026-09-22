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
      style = "night", 
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
      style = "dark", 
      transparent = false,
    },
  },

  -- 4. Catppuccin
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      flavour = "mocha", 
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

  {
    "LazyVim/LazyVim",
    opts = {
      -- "gruvbox" | "tokyonight" | "onedark" | "catppuccin" | "catppuccin-mocha" | "catppuccin-macchiato"
      colorscheme = "gruvbox",
    },
  },
}

