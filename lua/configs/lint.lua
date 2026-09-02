local lint = require "lint"

lint.linters_by_ft = {
  python = { "ruff" },

  javascript = { "eslint_d" },
  javascriptreact = { "eslint_d" },
  typescript = { "eslint_d" },
  typescriptreact = { "eslint_d" },

  c = { "cpplint" },
  cpp = { "cpplint" },

  cmake = { "cmakelint" },

  yaml = { "yamllint" },

  markdown = { "markdownlint" },

  bash = { "shellcheck" },
  sh = { "shellcheck" },

  dockerfile = { "hadolint" },

  sql = { "sqlfluff" },
}

local group = vim.api.nvim_create_augroup("NvimLint", {
  clear = true,
})

vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
  group = group,
  callback = function()
    -- nvim-lint silently skips linters that are not installed. This keeps
    -- the same config usable before and after Mason has installed tools.
    lint.try_lint(nil, { ignore_errors = true })
  end,
})

vim.keymap.set("n", "<leader>li", function()
  lint.try_lint(nil, { ignore_errors = true })
end, {
  desc = "Trigger linting",
})
