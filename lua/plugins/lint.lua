return {
  {
    "mfussenegger/nvim-lint",

    event = {
      "BufReadPre",
      "BufNewFile",
    },

    config = function()
      local lint = require("lint")

      lint.linters_by_ft = {
        python = {
          "ruff",
        },

        c = {
          "clangtidy",
        },

        cpp = {
          "clangtidy",
        },

        sh = {
          "shellcheck",
        },

        bash = {
          "shellcheck",
        },
      }

      local group = vim.api.nvim_create_augroup("UserLint", {
        clear = true,
      })

      vim.api.nvim_create_autocmd({
        "BufEnter",
        "BufWritePost",
        "InsertLeave",
      }, {
        group = group,

        callback = function()
          lint.try_lint()
        end,
      })
    end,
  },
}
