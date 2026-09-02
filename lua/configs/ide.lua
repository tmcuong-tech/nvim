local M = {}

vim.diagnostic.config {
  severity_sort = true,
  update_in_insert = false,
  underline = true,
  virtual_text = { spacing = 2, source = "if_many" },
  float = { border = "rounded", source = true },
}

local group = vim.api.nvim_create_augroup("IdeExperience", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
  group = group,
  callback = function()
    vim.hl.on_yank { higroup = "IncSearch", timeout = 150 }
  end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
  group = group,
  callback = function(event)
    local mark = vim.api.nvim_buf_get_mark(event.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(event.buf)
    if mark[1] > 0 and mark[1] <= line_count then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

vim.api.nvim_create_autocmd("LspAttach", {
  group = group,
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if not client then
      return
    end

    if client:supports_method "textDocument/inlayHint" then
      vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })
    end

    if client:supports_method "textDocument/codeLens" then
      if vim.lsp.codelens.enable then
        vim.lsp.codelens.enable(true, { bufnr = event.buf })
      else
        vim.lsp.codelens.refresh { bufnr = event.buf }
      end
    end
  end,
})

return M
