" ---- vim-airline ----
let g:airline_theme = 'gruvbox'
let g:airline_powerline_fonts = 1              " Requires a Nerd Font
let g:airline#extensions#tabline#enabled = 1   " Show buffer tabline
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline#extensions#branch#enabled = 1    " Show git branch (needs fugitive)
let g:airline#extensions#hunks#enabled = 1     " Show gitgutter hunk counts
let g:airline#extensions#coc#enabled = 1       " Show coc.nvim status/diagnostics
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
