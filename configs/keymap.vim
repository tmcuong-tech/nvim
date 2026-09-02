" ============================================================================
" Central key mappings
" Leader key: <Space>.  This file is the single place for user-defined maps.
" ============================================================================

" ---- Core Neovim (normal / visual) ----------------------------------------
nnoremap <silent> <M-Right> :vertical resize +1<CR>
nnoremap <silent> <M-Left>  :vertical resize -1<CR>
nnoremap <silent> <M-Down>  :resize +1<CR>
nnoremap <silent> <M-Up>    :resize -1<CR>
vnoremap // y/\V<C-R>=escape(@",'/\')<CR><CR>
nnoremap <silent> <leader>/ :nohlsearch<CR>

" ---- Startup banner (buffer-local) -----------------------------------------
augroup user_startup_banner_keymaps
  autocmd!
  autocmd User StartupBannerReady nnoremap <buffer><silent> q :qa<CR>
  autocmd User StartupBannerReady nnoremap <buffer><silent> e :enew<CR>
  autocmd User StartupBannerReady nnoremap <buffer><silent> f :Files<CR>
augroup END

" ---- Themes ----------------------------------------------------------------
let s:themes = ['gruvbox', 'onedark', 'tokyonight']
function! s:NextTheme() abort
  let l:index = index(s:themes, get(g:, 'colors_name', ''))
  execute 'colorscheme ' . s:themes[(l:index + 1) % len(s:themes)]
  echo 'Theme: ' . g:colors_name
endfunction
nnoremap <silent> th :call <SID>NextTheme()<CR>

" ---- fzf.vim ---------------------------------------------------------------
" ff: find files; <leader>fg: search text with ripgrep.
nnoremap <silent> ff :Files<CR>
nnoremap <silent> <leader>fg :Rg<CR>

" ---- NERDTree --------------------------------------------------------------
nnoremap <silent> <F5> :NERDTreeToggle<CR>
" The following keys are buffer-local to NERDTree, so they do not conflict
" with normal editing keys in file buffers.
function! s:NERDTreeAdd(node) abort
  call NERDTreeAddNode()
endfunction
function! s:NERDTreeRename(node) abort
  call NERDTreeMoveNode()
endfunction
function! s:NERDTreeDelete(node) abort
  let l:path = a:node.path.str()
  echo 'Delete ' . l:path . '? (y/N)'
  if nr2char(getchar()) !=# 'y'
    echo 'Delete aborted.'
    return
  endif
  try
    call a:node.delete()
    call NERDTreeRender()
    echo 'Deleted: ' . l:path
  catch /^NERDTree/
    call nerdtree#echoWarning('Could not remove: ' . l:path)
  endtry
endfunction
function! s:RegisterNERDTreeKeymaps() abort
  call NERDTreeAddKeyMap({
        \ 'key': 'a', 'scope': 'Node', 'callback': function('<SID>NERDTreeAdd'),
        \ 'quickhelpText': 'add file/folder (/ at the end)', 'override': 1 })
  call NERDTreeAddKeyMap({
        \ 'key': 'r', 'scope': 'Node', 'callback': function('<SID>NERDTreeRename'),
        \ 'quickhelpText': 'rename selected file/folder', 'override': 1 })
  call NERDTreeAddKeyMap({
        \ 'key': 'd', 'scope': 'Node', 'callback': function('<SID>NERDTreeDelete'),
        \ 'quickhelpText': 'delete selected file/folder (y/N)', 'override': 1 })
endfunction
augroup user_nerdtree_keymaps
  autocmd!
  autocmd VimEnter * call <SID>RegisterNERDTreeKeymaps()
augroup END

" ---- Current-file actions --------------------------------------------------
nnoremap <silent> <leader>R :call RenameCurrentFile()<CR>

" ---- Floaterm (normal / terminal) -----------------------------------------
nnoremap <silent> <leader>to :FloatermNew<CR>
tnoremap <silent> <leader>to <C-\><C-n>:FloatermNew<CR>
nnoremap <silent> <leader>tk :FloatermKill<CR>:FloatermPrev<CR>
tnoremap <silent> <leader>tk <C-\><C-n>:FloatermKill<CR>:FloatermPrev<CR>
nnoremap <silent> <leader>tn :FloatermNext<CR>
tnoremap <silent> <leader>tn <C-\><C-n>:FloatermNext<CR>
nnoremap <silent> <leader>tp :FloatermPrev<CR>
tnoremap <silent> <leader>tp <C-\><C-n>:FloatermPrev<CR>
nnoremap <silent> <leader>tt :FloatermToggle<CR>
tnoremap <silent> <leader>tt <C-\><C-n>:FloatermToggle<CR>
nnoremap <silent> <leader>tf <C-\><C-n><C-W><Left>
tnoremap <silent> <leader>tf <C-\><C-n><C-W><Left>
nnoremap <silent> <leader>gl :FloatermNew! --position=bottomright --height=0.95 --width=0.7 --title='GitLog' git lg<CR>

" ---- Git / vim-mergetool ---------------------------------------------------
nmap <silent> <leader>mt <Plug>(MergetoolToggle)

" ---- vimspector ------------------------------------------------------------
nnoremap <silent> <leader>dl :call vimspector#Launch()<CR>
nnoremap <silent> <leader>ds :call vimspector#Reset()<CR>
nnoremap <silent> <leader>dc :call vimspector#Continue()<CR>
nnoremap <silent> <leader>dt :call vimspector#ToggleBreakpoint()<CR>
nnoremap <silent> <leader>dT :call vimspector#ClearBreakpoints()<CR>
nmap <silent> <leader>dr <Plug>VimspectorRestart
nmap <silent> <leader>de <Plug>VimspectorStepOut
nmap <silent> <leader>di <Plug>VimspectorStepInto
nmap <silent> <leader>do <Plug>VimspectorStepOver

" ---- coc.nvim: completion (insert) ----------------------------------------
inoremap <silent><expr> <TAB> coc#pum#visible() ? coc#pum#next(1) : CheckBackspace() ? "\<Tab>" : coc#refresh()
inoremap <expr> <S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
if has('nvim')
  inoremap <silent><expr> <C-Space> coc#refresh()
else
  inoremap <silent><expr> <C-@> coc#refresh()
endif

" ---- coc.nvim: navigation and code actions (normal / visual) -------------
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nnoremap <silent> K :call ShowDocumentation()<CR>
nmap <silent> <leader>rn <Plug>(coc-rename)
xmap <leader>f <Plug>(coc-format-selected)
nmap <leader>f <Plug>(coc-format-selected)
xmap <leader>a <Plug>(coc-codeaction-selected)
nmap <leader>a <Plug>(coc-codeaction-selected)
nmap <leader>ac <Plug>(coc-codeaction-cursor)
nmap <leader>as <Plug>(coc-codeaction-source)
nmap <leader>qf <Plug>(coc-fix-current)
nmap <silent> <leader>re <Plug>(coc-codeaction-refactor)
xmap <silent> <leader>r <Plug>(coc-codeaction-refactor-selected)
nmap <silent> <leader>r <Plug>(coc-codeaction-refactor-selected)
nmap <leader>cl <Plug>(coc-codelens-action)
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<C-r>=coc#float#scroll(1)\<CR>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<C-r>=coc#float#scroll(0)\<CR>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)
nnoremap <silent><nowait> <space>a :<C-u>CocList diagnostics<CR>
nnoremap <silent><nowait> <space>e :<C-u>CocList extensions<CR>
nnoremap <silent><nowait> <space>c :<C-u>CocList commands<CR>
nnoremap <silent><nowait> <space>o :<C-u>CocList outline<CR>
nnoremap <silent><nowait> <space>s :<C-u>CocList -I symbols<CR>
nnoremap <silent><nowait> <space>j :<C-u>CocNext<CR>
nnoremap <silent><nowait> <space>k :<C-u>CocPrev<CR>
nnoremap <silent><nowait> <space>p :<C-u>CocListResume<CR>
