-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

map("n", "<leader>w", "<cmd>w<cr>", { desc = "Save" })
map("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })
map("n", "<leader>wq", "<cmd>wq<cr>", { desc = "Save and Quit" })

map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear Search" })

map("n", "<C-h>", "<C-w>h", { desc = "Go Left Window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go Down Window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go Up Window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go Right Window" })

map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase Height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Width" })

map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Previous Buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next Buffer" })

map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete Buffer" })

map("n", "<leader>xx", vim.diagnostic.setloclist, { desc = "Diagnostics List" })
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })

map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })
map("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename" })
map("n", "gd", vim.lsp.buf.definition, { desc = "Go to Definition" })
map("n", "gD", vim.lsp.buf.declaration, { desc = "Go to Declaration" })
map("n", "gr", vim.lsp.buf.references, { desc = "References" })
map("n", "gi", vim.lsp.buf.implementation, { desc = "Implementation" })
map("n", "K", vim.lsp.buf.hover, { desc = "Hover Documentation" })

map("n", "<leader>fm", function()
  require("conform").format({ async = true, lsp_fallback = true })
end, { desc = "Format" })
