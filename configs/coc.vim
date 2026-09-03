" Coc is the only LSP/completion client for these filetypes.
" Assembly and Lua are intentionally handled by native LSP in configs/lsp.vim.
let g:coc_global_extensions = [
      \ 'coc-clangd',
      \ 'coc-pyright',
      \ 'coc-java',
      \ 'coc-rust-analyzer',
      \ 'coc-sh',
      \ 'coc-json',
      \ 'coc-snippets',
      \ 'coc-css',
      \ 'coc-html',
      \ 'coc-vimlsp',
      \ 'coc-tsserver',
      \ 'coc-cmake',
      \ 'coc-yaml',
      \ 'coc-svelte',
      \ ]

function! CheckBackspace() abort
  let l:column = col('.') - 1
  return !l:column || getline('.')[l:column - 1] =~# '\s'
endfunction

function! ShowDocumentation() abort
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

function! s:DisableCocForNativeLsp() abort
  let b:coc_suggest_disable = 1
  let b:coc_inline_disable = 1
  let b:coc_diagnostic_disable = 1
  let b:coc_disable_autoformat = 1
endfunction

" Completion.
inoremap <silent><expr> <Tab>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <silent><expr> <S-Tab> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
      \ : "\<C-g>u\<CR>\<C-r>=coc#on_enter()\<CR>"

if has('nvim')
  inoremap <silent><expr> <C-Space> coc#refresh()
else
  inoremap <silent><expr> <C-@> coc#refresh()
endif

" Navigation and documentation.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nnoremap <silent> K :call ShowDocumentation()<CR>

augroup coc_user_settings
  autocmd!
  autocmd CursorHold * silent call CocActionAsync('highlight')
  autocmd FileType asm,vmasm,lua,go,gomod,gowork,gotmpl call <SID>DisableCocForNativeLsp()
  " Only set formatexpr where the configured server has a formatter available.
  autocmd FileType c,cpp,java,rust,javascript,typescript,json,css,html
        \ setlocal formatexpr=CocAction('formatSelected')
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup END

" Refactoring, formatting and code actions.
nmap <silent> <leader>rn <Plug>(coc-rename)
xmap <silent> <leader>f <Plug>(coc-format-selected)
nmap <silent> <leader>f <Plug>(coc-format-selected)
xmap <silent> <leader>aa <Plug>(coc-codeaction-selected)
nmap <silent> <leader>aa <Plug>(coc-codeaction-selected)
nmap <silent> <leader>ac <Plug>(coc-codeaction-cursor)
nmap <silent> <leader>as <Plug>(coc-codeaction-source)
nmap <silent> <leader>qf <Plug>(coc-fix-current)
nmap <silent> <leader>re <Plug>(coc-codeaction-refactor)
xmap <silent> <leader>r <Plug>(coc-codeaction-refactor-selected)
nmap <silent> <leader>r <Plug>(coc-codeaction-refactor-selected)
nmap <silent> <leader>al <Plug>(coc-codelens-action)

" Function and class text objects.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Scroll Coc floating windows while preserving the normal keys otherwise.
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

command! -nargs=0 Format call CocActionAsync('format')
command! -nargs=? Fold call CocAction('fold', <f-args>)
command! -nargs=0 OR call CocActionAsync('runCommand', 'editor.action.organizeImport')

" Coc lists use the <leader>l namespace to avoid NERDCommenter's <leader>c maps.
nnoremap <silent><nowait> <leader>ld :<C-u>CocList diagnostics<CR>
nnoremap <silent><nowait> <leader>le :<C-u>CocList extensions<CR>
nnoremap <silent><nowait> <leader>lc :<C-u>CocList commands<CR>
nnoremap <silent><nowait> <leader>lo :<C-u>CocList outline<CR>
nnoremap <silent><nowait> <leader>ls :<C-u>CocList -I symbols<CR>
nnoremap <silent><nowait> <leader>lj :<C-u>CocNext<CR>
nnoremap <silent><nowait> <leader>lk :<C-u>CocPrev<CR>
nnoremap <silent><nowait> <leader>lp :<C-u>CocListResume<CR>
