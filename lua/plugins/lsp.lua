return {
  {
    "neovim/nvim-lspconfig",

    opts = {
      servers = {
        clangd = {
          cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy",
            "--completion-style=detailed",
            "--header-insertion=iwyu",
          },
        },

        pyright = {},

        jdtls = {},

        omnisharp = {},

        bashls = {},

        html = {},

        cssls = {},

        marksman = {},

        cmake = {},
      },
    },
  },
}
