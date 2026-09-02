" ---- ASCII banner will open after open with no file ----
function! s:ShowBanner() abort
  if argc() != 0 || line2byte('$') != -1
    return
  endif

  let s:wide_banner = [
        \ '████████╗███╗   ███╗ ██████╗██╗   ██╗ ██████╗ ███╗   ██╗ ██████╗ ',
        \ '╚══██╔══╝████╗ ████║██╔════╝██║   ██║██╔═══██╗████╗  ██║██╔════╝ ',
        \ '   ██║   ██╔████╔██║██║     ██║   ██║██║   ██║██╗██╗ ██║██║      ',
        \ '   ██║   ██║╚██╔╝██║██║     ██║   ██║██║   ██║██║╚██╗██║██║   ██║',
        \ '   ██║   ██║ ╚═╝ ██║╚██████╗╚██████╔╝╚██████╔╝██║ ╚████║╚██████╔╝',
        \ '   ╚═╝   ╚═╝     ╚═╝ ╚═════╝ ╚═════╝  ╚═════╝ ╚═╝  ╚═══╝ ╚═════╝ ',
        \ ]


  enew
  setlocal buftype=nofile bufhidden=wipe noswapfile nobuflisted
  setlocal nonumber norelativenumber nocursorline signcolumn=no nowrap
  setlocal fillchars=eob:\ 
  let b:is_startup_banner = 1
  call s:RenderBanner(bufnr('%'), winwidth(0), winheight(0))
  doautocmd User StartupBannerReady
endfunction

function! s:RenderBanner(bufnr, width, height) abort
  let l:banner = a:width >= 80 ? s:wide_banner : s:compact_banner
  let l:centered = []
  for l:line in l:banner
    let l:pad = (a:width - strdisplaywidth(l:line)) / 2
    call add(l:centered, repeat(' ', max([l:pad, 0])) . l:line)
  endfor

  let l:top_pad = max([(a:height - len(l:centered)) / 2, 0])
  call setbufvar(a:bufnr, '&modifiable', 1)
  call deletebufline(a:bufnr, 1, '$')
  call setbufline(a:bufnr, 1, repeat([''], l:top_pad) + l:centered)
  call setbufvar(a:bufnr, '&modifiable', 0)
  call setbufvar(a:bufnr, '&modified', 0)
endfunction

function! s:RefreshBanners(...) abort
  for l:window in getwininfo()
    if getbufvar(l:window.bufnr, 'is_startup_banner', 0)
      call s:RenderBanner(l:window.bufnr, winwidth(l:window.winid), winheight(l:window.winid))
    endif
  endfor
endfunction

function! s:CloseBannerForFile() abort
  if getbufvar(bufnr('%'), 'is_startup_banner', 0)
        \ || &l:buftype !=# '' || empty(bufname('%'))
        \ || getbufvar(bufnr('%'), 'NERDTree', 0)
        \ || &l:filetype ==# 'nerdtree'
        \ || bufname('%') =~# '^NERD_tree_'
    return
  endif

  for l:window in getwininfo()
    if getbufvar(l:window.bufnr, 'is_startup_banner', 0)
      call win_execute(l:window.winid, 'silent! close')
    endif
  endfor
endfunction

augroup startup_banner
  autocmd!
  autocmd VimEnter * call s:ShowBanner()
  autocmd BufEnter,BufWinEnter * call s:CloseBannerForFile()
  autocmd WinResized * call s:RefreshBanners()
  autocmd WinClosed * call timer_start(0, function('<SID>RefreshBanners'))
  autocmd User NERDTreeInit call s:RefreshBanners()
augroup END
