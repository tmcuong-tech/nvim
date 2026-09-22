return {
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        python = { "ruff" },
        c = { "clangtidy" },
        cpp = { "clangtidy" },
        sh = { "shellcheck" },
        bash = { "shellcheck" },
      },
    },
  },
}
