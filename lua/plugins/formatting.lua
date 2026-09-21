return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        c = { "clang_format" },
        cpp = { "clang_format" },
        java = { "google-java-format" },
        python = { "black", "isort" },
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
        cmake = { "cmake_format" },
      },

      format_on_save = {
        timeout_ms = 3000,
        lsp_fallback = true,
      },
    },
  },
}
