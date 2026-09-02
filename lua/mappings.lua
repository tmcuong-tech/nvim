require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>", { desc = "Exit insert mode" })

map("n", "<leader>ih", function()
  local bufnr = vim.api.nvim_get_current_buf()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = bufnr }, { bufnr = bufnr })
end, { desc = "LSP: Toggle inlay hints" })

map("n", "<leader>cl", vim.lsp.codelens.run, { desc = "LSP: Run code lens" })
map("n", "<leader>e", vim.diagnostic.open_float, { desc = "Diagnostics: Show details" })
map("n", "[d", function()
  vim.diagnostic.jump { count = -1, float = true }
end, { desc = "Diagnostics: Previous" })
map("n", "]d", function()
  vim.diagnostic.jump { count = 1, float = true }
end, { desc = "Diagnostics: Next" })

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
