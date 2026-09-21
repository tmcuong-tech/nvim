return {
  {
    "nvim-treesitter/nvim-treesitter",

    opts = {
      ensure_installed = {
        "c",
        "cpp",
        "python",
        "java",
        "c_sharp",

        "bash",
        "lua",

        "html",
        "css",

        "cmake",
        "markdown",
        "markdown_inline",

        "json",
        "yaml",
        "toml",
        "vim",
        "vimdoc",
        "query",
      },

      highlight = {
        enable = true,
      },

      indent = {
        enable = true,
      },
    },
  },
}
