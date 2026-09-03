"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Settings for neovim-qt
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Guard Neovim-Qt-only commands so other GUIs can source this file safely.
if exists(':GuiPopupmenu')
  GuiPopupmenu 0
endif

" Enable line
if exists(':GuiLinespace')
  GuiLinespace 1
endif

" Disable qt tab line 
if exists(':GuiTabline')
  GuiTabline 0
endif

" Set format of tab name 
if exists('+guitablabel')
  set guitablabel=\[%N\]\ %t\ %M
endif

" Neovim-Qt font. Spaces must be escaped in a Vim option value.
set guifont=JetBrainsMono\ Nerd\ Font:h12

" Set key map to paste 
inoremap <silent> <S-Insert> <C-R>+
