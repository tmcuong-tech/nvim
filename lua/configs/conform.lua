local options = {
  formatters_by_ft = {
    c = { "clang_format" },
    cpp = { "clang_format" },

    python = { "ruff_format" },

    rust = { "rustfmt" },

    go = { "gofmt" },

    java = { "google-java-format" },

    javascript = { "prettier" },
    javascriptreact = { "prettier" },
    typescript = { "prettier" },
    typescriptreact = { "prettier" },

    html = { "prettier" },
    css = { "prettier" },
    json = { "prettier" },
    jsonc = { "prettier" },

    yaml = { "yamlfmt" },

    bash = { "shfmt" },
    sh = { "shfmt" },

    lua = { "stylua" },

    asm = { "asmfmt" },

    markdown = { "prettier" },

    cmake = { "cmake_format" },
  },

  -- Auto format trước khi :w
  format_on_save = {
    timeout_ms = 1000,
    lsp_format = "fallback",
  },

  notify_on_error = false,
  notify_no_formatters = false,
}

return options
