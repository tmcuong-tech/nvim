return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        c = { "clang-format" },
        cpp = { "clang-format" },
        java = { "google-java-format" },
        python = { "isort", "black" },
        cs = { "csharpier" },
        asm = { "asmfmt" },
        nasm = { "asmfmt" },
        sh = { "shfmt" },
        bash = { "shfmt" },
        html = { "prettier" },
        css = { "prettier" },
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        cmake = { "cmake-format" },
      },
      -- Để LazyVim quản lý format_on_save qua LazyVim.format (bật/tắt linh hoạt bằng <leader>uf)
    },
  },
}
