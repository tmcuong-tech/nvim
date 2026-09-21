return {
  {
    "saghen/blink.cmp",
    opts = {
      completion = {
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
        },

        menu = {
          border = "rounded",
        },

        ghost_text = {
          enabled = true,
        },
      },

      sources = {
        default = {
          "lsp",
          "path",
          "snippets",
          "buffer",
        },
      },

      keymap = {
        preset = "default",

        ["<C-Space>"] = { "show" },

        ["<CR>"] = {
          "accept",
          "fallback",
        },

        ["<Tab>"] = {
          "select_next",
          "snippet_forward",
          "fallback",
        },

        ["<S-Tab>"] = {
          "select_prev",
          "snippet_backward",
          "fallback",
        },

        ["<C-n>"] = {
          "select_next",
          "fallback",
        },

        ["<C-p>"] = {
          "select_prev",
          "fallback",
        },
      },
    },
  },
}
