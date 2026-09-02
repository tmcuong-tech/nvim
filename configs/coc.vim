" coc.nvim settings. All user key mappings live in configs/keymap.vim.
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

augroup coc_user_settings
  autocmd!
  autocmd CursorHold * silent call CocActionAsync('highlight')
  autocmd FileType typescript,json setlocal formatexpr=CocAction('formatSelected')
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup END

command! -nargs=0 Format call CocActionAsync('format')
command! -nargs=? Fold call CocAction('fold', <f-args>)
command! -nargs=0 OR call CocActionAsync('runCommand', 'editor.action.organizeImport')
