return {
  -- Vô hiệu hóa mini.pairs mặc định của LazyVim để tránh xung đột đúp dấu ngoặc đơn
  {
    "nvim-mini/mini.pairs",
    enabled = false,
  },

  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      check_ts = true,
      fast_wrap = {
        map = "<M-e>",
        chars = {
          "{",
          "[",
          "(",
          '"',
          "'",
        },
      },
      disable_filetype = {
        "TelescopePrompt",
        "spectre_panel",
        "snacks_picker_input",
      },
    },
  },
}
