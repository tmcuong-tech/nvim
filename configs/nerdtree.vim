" F5 to toggle.
nnoremap <silent> <F5> :NERDTreeToggle<CR>

" Open the existing NERDTree on each new tab.
"autocmd BufWinEnter * silent NERDTreeMirror

" Keep project-root detection stable for LSP, FZF and terminals.
let g:NERDTreeChDirMode = 0

" Change arrow to expand/collapse tree
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'

"let NERDTreeMapOpenInTab='<ENTER>'

" Git status icon
let g:NERDTreeGitStatusIndicatorMapCustom = {
                \ 'Modified'  :'✹',
                \ 'Staged'    :'✚',
                \ 'Untracked' :'✭',
                \ 'Renamed'   :'➜',
                \ 'Unmerged'  :'═',
                \ 'Deleted'   :'✖',
                \ 'Dirty'     :'✗',
                \ 'Ignored'   :'☒',
                \ 'Clean'     :'✔︎',
                \ 'Unknown'   :'?',
                \ }

" Hightlight current file
let g:nerdtree_sync_cursorline = 1

function! s:KeepNERDTreeWindow() abort
  if bufname('#') =~# 'NERD_tree_\d\+'
        \ && bufname('%') !~# 'NERD_tree_\d\+' && winnr('$') > 1
    let l:buffer = bufnr()
    buffer#
    wincmd w
    execute 'buffer ' . l:buffer
  endif
endfunction

augroup user_nerdtree
  autocmd!
  " Exit Neovim if NERDTree is the only window left.
  autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1
        \ && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
  autocmd BufEnter * call <SID>KeepNERDTreeWindow()
augroup END

" Start NERDTree when Vim starts with a directory argument.
" autocmd StdinReadPre * let s:std_in=1
" autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists('s:std_in') |
"     \ execute 'NERDTree' argv()[0] | wincmd p | enew | execute 'cd '.argv()[0] | endif

" auto open a nerdtree buffer on open.
" autocmd vimenter * if !argc() | NERDTree | endif

" autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Ignore some type of files: 
let NERDTreeIgnore=['__pycache__', 'site-packages']
