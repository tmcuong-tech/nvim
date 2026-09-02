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

local group = vim.api.nvim_create_augroup("NvimLint", { clear = true })
local timers = {}

local function lint_buffer(bufnr)
  if not vim.api.nvim_buf_is_valid(bufnr) or not vim.api.nvim_buf_is_loaded(bufnr) then
    return
  end

  -- nvim-lint operates on the current buffer. Restore the buffer context here
  -- because the user may switch buffers while the debounce timer is pending.
  vim.api.nvim_buf_call(bufnr, function()
    lint.try_lint(nil, { ignore_errors = true })
  end)
end

vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "InsertLeave" }, {
  group = group,
  callback = function(event)
    local bufnr = event.buf
    if timers[bufnr] then
      timers[bufnr]:stop()
    else
      timers[bufnr] = vim.uv.new_timer()
    end

    timers[bufnr]:start(
      200,
      0,
      vim.schedule_wrap(function()
        lint_buffer(bufnr)
      end)
    )
  end,
})

vim.api.nvim_create_autocmd("BufWipeout", {
  group = group,
  callback = function(event)
    local timer = timers[event.buf]
    if timer then
      timer:stop()
      timer:close()
      timers[event.buf] = nil
    end
  end,
})

vim.keymap.set("n", "<leader>li", function()
  lint_buffer(vim.api.nvim_get_current_buf())
end, {
  desc = "Trigger linting",
})
