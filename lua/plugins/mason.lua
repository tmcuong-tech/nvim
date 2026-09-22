return {
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "clangd",
        "clang-format",
        "codelldb",

        "pyright",
        "black",
        "isort",
        "debugpy",
        "ruff",

        "jdtls",
        "google-java-format",

        "omnisharp",
        "csharpier",

        "bash-language-server",
        "shellcheck",
        "shfmt",

        "marksman",
        "prettier",
        "cmakelang",
      })
    end,
  },
}
