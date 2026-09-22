return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      diagnostics = {
        underline = true,
        update_in_insert = true, -- Hiển thị và cập nhật lỗi realtime khi đang gõ trong Insert mode
        virtual_text = {
          spacing = 4,
          source = "if_many",
          prefix = "●",
        },
        severity_sort = true,
      },
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
