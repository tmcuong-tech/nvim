" Rename the file for the current buffer.
function! RenameCurrentFile() abort
  let l:old_name = expand('%:p')
  if empty(l:old_name)
    echoerr 'The current buffer is not associated with a file.'
    return
  endif

  let l:new_name = input('Rename file to: ', l:old_name, 'file')
  if empty(l:new_name) || l:new_name ==# l:old_name
    return
  endif

  let l:new_name = fnamemodify(l:new_name, ':p')
  if filereadable(l:new_name) || isdirectory(l:new_name)
    echoerr 'The destination already exists: ' . l:new_name
    return
  endif

  update
  if rename(l:old_name, l:new_name) != 0
    echoerr 'Unable to rename: ' . l:old_name
    return
  endif

  execute 'file ' . fnameescape(l:new_name)
  echo 'Renamed to ' . l:new_name
endfunction
