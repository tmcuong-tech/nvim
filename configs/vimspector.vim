" Reproducible cross-platform adapters. Run :VimspectorInstall once after
" cloning; Vimspector downloads the correct build for Windows or Linux.
let g:vimspector_install_gadgets = [
      \ 'CodeLLDB',
      \ 'debugpy',
      \ 'delve',
      \ 'vscode-js-debug',
      \ 'vscode-bash-debug',
      \ 'vscode-java-debug',
      \ ]

let s:debug_executable = '${workspaceRoot}/build/${fileBasenameNoExtension}'
if has('win32')
  let s:debug_executable .= '.exe'
endif

" Useful defaults work without a project file. A project's .vimspector.json
" can add or override configurations for arguments, environment and binaries.
let g:vimspector_configurations = {
      \ 'Python - current file': {
      \   'adapter': 'debugpy',
      \   'filetypes': ['python'],
      \   'configuration': {
      \     'request': 'launch',
      \     'program': '${file}',
      \     'cwd': '${fileDirname}',
      \     'console': 'integratedTerminal',
      \   },
      \ },
      \ 'C/C++ - launch binary': {
      \   'adapter': 'CodeLLDB',
      \   'filetypes': ['c', 'cpp', 'rust'],
      \   'configuration': {
      \     'request': 'launch',
      \     'program': s:debug_executable,
      \     'cwd': '${workspaceRoot}',
      \     'stopOnEntry': v:false,
      \   },
      \ },
      \ 'Go - current package': {
      \   'adapter': 'delve',
      \   'filetypes': ['go'],
      \   'configuration': {
      \     'request': 'launch',
      \     'program': '${fileDirname}',
      \     'mode': 'debug',
      \   },
      \ },
      \ 'JavaScript - current file': {
      \   'adapter': 'js-debug',
      \   'filetypes': ['javascript'],
      \   'configuration': {
      \     'request': 'launch',
      \     'type': 'pwa-node',
      \     'program': '${file}',
      \     'cwd': '${workspaceRoot}',
      \   },
      \ },
      \ }

nnoremap <silent> <Leader>dl :call vimspector#Launch()<CR>
nnoremap <silent> <Leader>ds :call vimspector#Reset()<CR>
nnoremap <silent> <Leader>dc :call vimspector#Continue()<CR>

nnoremap <silent> <Leader>dt :call vimspector#ToggleBreakpoint()<CR>
nnoremap <silent> <Leader>dT :call vimspector#ClearBreakpoints()<CR>

nmap      <Leader>dr <Plug>VimspectorRestart
nmap      <Leader>de <Plug>VimspectorStepOut
nmap      <Leader>di <Plug>VimspectorStepInto
nmap      <Leader>do <Plug>VimspectorStepOver
