-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt
local g = vim.g

g.mapleader = " "
g.maplocalleader = " "

opt.encoding = "utf-8"
opt.fileencoding = "utf-8"
opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.showmode = false

opt.updatetime = 200
opt.updatecount = 100
opt.timeout = true
opt.timeoutlen = 300

opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"
opt.cursorline = true

opt.wrap = false
opt.breakindent = true
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.smoothscroll = true

opt.wildmenu = true
opt.wildmode = "longest:full,full"

opt.list = true
opt.listchars = {
  tab = "→ ",
  trail = "·",
  nbsp = "␣",
  extends = "›",
  precedes = "‹",
}

opt.expandtab = true
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.autoindent = true
opt.smartindent = true

opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

opt.backup = false
opt.writebackup = false
opt.swapfile = false
opt.undofile = true
opt.hidden = true
opt.autoread = true
opt.confirm = true

opt.completeopt = {
  "menu",
  "menuone",
  "noselect",
}

opt.pumheight = 10
opt.pumblend = 0

opt.splitright = true
opt.splitbelow = true

opt.redrawtime = 10000
opt.maxmempattern = 20000

opt.foldenable = true
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldcolumn = "1"
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"

opt.termguicolors = true
opt.background = "dark"
opt.cmdheight = 1
opt.showtabline = 1

opt.modeline = false

g.netrw_banner = 0

vim.diagnostic.config({
  virtual_text = false,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "✗",
      [vim.diagnostic.severity.WARN] = "✗",
      [vim.diagnostic.severity.HINT] = "✗",
      [vim.diagnostic.severity.INFO] = "✗",
    },
  },
  underline = true,
  update_in_insert = true,
  severity_sort = true,
  float = {
    border = "rounded",
    source = "if_many",
    header = "",
    prefix = "",
    suffix = "",
  },
})

vim.api.nvim_set_hl(0, "DiagnosticSignError", { fg = "#f38ba8" })
vim.api.nvim_set_hl(0, "DiagnosticSignWarn", { fg = "#f38ba8" })
vim.api.nvim_set_hl(0, "DiagnosticSignHint", { fg = "#f38ba8" })
vim.api.nvim_set_hl(0, "DiagnosticSignInfo", { fg = "#f38ba8" })

vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local line_count = vim.api.nvim_buf_line_count(0)

    if mark[1] > 0 and mark[1] <= line_count then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})
