"   ████████╗███╗   ███╗ ██████╗██╗   ██╗ ██████╗ ███╗   ██╗ ██████╗ 
"   ╚══██╔══╝████╗ ████║██╔════╝██║   ██║██╔═══██╗████╗  ██║██╔════╝ 
"      ██║   ██╔████╔██║██║     ██║   ██║██║   ██║██╔██╗ ██║██║  ███╗
"      ██║   ██║╚██╔╝██║██║     ██║   ██║██║   ██║██║╚██╗██║██║   ██║
"      ██║   ██║ ╚═╝ ██║╚██████╗╚██████╔╝╚██████╔╝██║ ╚████║╚██████╔╝
"      ╚═╝   ╚═╝     ╚═╝ ╚═════╝ ╚═════╝  ╚═════╝ ╚═╝  ╚═══╝ ╚═════╝ 
"
" github.com/tmcuong-tech

lua print('Neovim started...')

" => General settings
set number                  " Show line number
set relativenumber          " Show relative line
set mouse=a                 " Enable mouse
set expandtab               " Tab setting 
set tabstop=4               " Tab setting 
set shiftwidth=4            " Tab setting
set listchars=tab:\¦\       " Tab charactor 
set list
set foldmethod=syntax         
set foldnestmax=1
set foldlevelstart=3        "  
set ignorecase              " Enable case-insensitive search (smartcase below refines it)
set smartcase               " Override ignorecase when search has uppercase letters
set hlsearch                " Highlight all search matches (default in Nvim, set explicitly for clarity)
set incsearch               " Show matches while typing the search pattern
set updatetime=300          " Faster LSP highlights and CursorHold events
set signcolumn=no           " Show diagnostics inline; do not reserve a sign column
set encoding=utf-8
let mapleader = ' '

" Prefer a UTF-8 character locale without overriding an already valid locale.
" C.UTF-8 is commonly available on Linux; en_US.UTF-8 is also understood by
" Neovim's Windows runtime.
if v:ctype ==# 'C'
  silent! language ctype C.UTF-8
  if v:ctype ==# 'C'
    silent! language ctype en_US.UTF-8
  endif
endif

" Git for Windows ships the archive tools Mason needs. Append them only when
" the corresponding commands are otherwise unavailable, preserving user PATH
" precedence and leaving Linux/macOS untouched.
if has('win32') && (!executable('gzip') || !executable('unzip')) && executable('git')
  let s:git_usr_bin = fnamemodify(exepath('git'), ':h:h') . '/usr/bin'
  if isdirectory(s:git_usr_bin)
    let $PATH .= ';' . s:git_usr_bin
  endif
endif

" Keep recovery files outside projects on Windows, Linux and macOS.
let s:recovery_root = stdpath('state') . '/recovery'
for s:recovery_dir in ['backup', 'swap', 'undo']
  call mkdir(s:recovery_root . '/' . s:recovery_dir, 'p', 0700)
endfor
let &backupdir = s:recovery_root . '/backup//'
let &directory = s:recovery_root . '/swap//'
let &undodir = s:recovery_root . '/undo//'

" A write-backup protects the file while it is being replaced. Swap and
" persistent undo protect unsaved work and edit history after a crash.
set nobackup
set writebackup
set swapfile
set undofile

" This configuration does not use Node, Perl or Ruby remote plugins. Disabling the
" unused providers avoids platform-dependent health warnings and startup work.
let g:loaded_node_provider = 0
let g:loaded_perl_provider = 0
let g:loaded_ruby_provider = 0

" Optimize 
set synmaxcol=3000    "Prevent breaking syntax hightlight when string too long. Max = 3000"
set lazyredraw
augroup user_json_folding
  autocmd!
  autocmd BufNewFile,BufRead *.json setlocal foldmethod=indent
augroup END
 
syntax on

" Enable copying from vim to clipboard
if has('win32')
  set clipboard=unnamed
else
  set clipboard=unnamedplus
endif

" => Plugin list
" Bootstrap vim-plug on a new machine. Git is the only required installer.
let s:plug_site_file = stdpath('data') . '/site/autoload/plug.vim'
let s:plug_repo_dir = stdpath('data') . '/vim-plug'
let s:plug_repo_file = s:plug_repo_dir . '/plug.vim'

if filereadable(s:plug_site_file)
  execute 'source ' . fnameescape(s:plug_site_file)
elseif filereadable(s:plug_repo_file)
  execute 'source ' . fnameescape(s:plug_repo_file)
else
  if !executable('git')
    echohl ErrorMsg
    echom 'Git is required to install vim-plug. Install Git, then restart Neovim.'
    echohl None
    finish
  endif

  echom 'Installing vim-plug...'
  let s:plug_clone_output = system([
        \ 'git', 'clone', '--filter=blob:none', '--depth=1',
        \ 'https://github.com/junegunn/vim-plug.git', s:plug_repo_dir,
        \ ])
  if v:shell_error || !filereadable(s:plug_repo_file)
    echohl ErrorMsg
    echom 'Unable to install vim-plug: ' . s:plug_clone_output
    echohl None
    finish
  endif
  execute 'source ' . fnameescape(s:plug_repo_file)
endif

call plug#begin(stdpath('config').'/plugged')
  " Colorschemes
  Plug 'morhetz/gruvbox', {'commit': '5d15b2765f59754d7ac263c88a0f6e3e58124951'}
  Plug 'joshdick/onedark.vim', {'commit': '47bec7a6196a843dad195d2666c3ac84c6e80c78'}
  Plug 'folke/tokyonight.nvim', {'commit': 'cdc07ac78467a233fd62c493de29a17e0cf2b2b6'}

  " Status bar
  Plug 'vim-airline/vim-airline', {'commit': '192c2c7e8e58fcc771b1959e633b963984319a7c'}
  Plug 'vim-airline/vim-airline-themes', {'commit': '77aab8c6cf7179ddb8a05741da7e358a86b2c3ab'}

  " File browser
  Plug 'preservim/nerdTree', {'commit': '690d061b591525890f1471c6675bcb5bdc8cdff9'}
  Plug 'Xuyuanp/nerdtree-git-plugin', {'commit': 'e1fe727127a813095854a5b063c15e955a77eafb'}
  Plug 'ryanoasis/vim-devicons', {'commit': '71f239af28b7214eebb60d4ea5bd040291fb7e33'}
  Plug 'unkiwii/vim-nerdtree-sync', {'commit': 'f0ec649ac2045f6bf9e32efffbdc3e7aaee419d2'}
  Plug 'jcharum/vim-nerdtree-syntax-highlight',
    \ {'branch': 'escape-keys', 'commit': '1b9ea66d051655734b5e82d3017ea3687a67acb2'}
  
  " File search
  Plug 'junegunn/fzf', 
    \ {'commit': '52f4319a72c17e123396cc3a2e6abf2e96e9d753', 'do': { -> fzf#install() }}
  Plug 'junegunn/fzf.vim', {'commit': 'd2a59a992a2455f609c0fde2ebd84427ea8f919a'}

  " Terminal
  Plug 'voldikss/vim-floaterm', {'commit': '7712701c5d20a0f9c935fbc2a6334083ce89b558'}

  " Native LSP management for all configured languages.
  Plug 'neovim/nvim-lspconfig', {'commit': '85e732c62ac59ab7c12df71ddd020baa87948390'}
  Plug 'mason-org/mason.nvim', {'commit': '2a6940af80375532e5e9e7c1f2fc6319a1b7a69d'}
  Plug 'mason-org/mason-lspconfig.nvim', {'commit': '40276c4df7e6bdce6801d6c035c6227f9115a855'}

  " Code syntax highlight
  Plug 'sheerun/vim-polyglot', {'commit': 'f061eddb7cdcc614c8406847b2bfb53099832a4e'}

  " Debugging
  Plug 'puremourning/vimspector', {'commit': '34099d18d8957bb3db5f396c8ca993ffb246a437'}

  " Source code version control 
  Plug 'tpope/vim-fugitive', {'commit': '3b753cf8c6a4dcde6edee8827d464ba9b8c4a6f0'}
  Plug 'tpope/vim-rhubarb', {'commit': '5496d7c94581c4c9ad7430357449bb57fc59f501'}
  Plug 'airblade/vim-gitgutter', {'commit': '90b75207bd9b55d8ac4af15f72b4e935462014d0'}
  Plug 'samoshkin/vim-mergetool', {'commit': '0275a85256ad173e3cde586d54f66566c01b607f'}

  " Fold 
  Plug 'tmhedberg/SimpylFold', {'commit': 'ff4c85197c5555715093c08a8d4f9d493c4d80cd'}

  " Editing helpers
  Plug 'jiangmiao/auto-pairs', {'commit': '39f06b873a8449af8ff6a3eee716d3da14d63a76'}
  Plug 'mattn/emmet-vim', {'commit': '92ef2f74f4093edc99db5e9e4cf7e40116a85bd6'}
  Plug 'preservim/nerdcommenter', {'commit': 'a462bbda1e26f44fb3d3eb9d9d1c6a07aa98e665'}

  call plug#end()

" Install missing plugins automatically after the first clone.
let s:missing_plugins = filter(copy(values(g:plugs)), { _, plugin -> !isdirectory(plugin.dir) })
if !empty(s:missing_plugins)
  augroup user_plug_bootstrap
    autocmd!
    autocmd VimEnter * ++once PlugInstall --sync | source $MYVIMRC
  augroup END
endif

" => Plugin settings
set termguicolors
set background=dark

function! s:ApplyThemeOverrides() abort
  highlight Normal guibg=NONE ctermbg=NONE
  highlight NonText guibg=NONE ctermbg=NONE
  highlight NormalFloat guibg=NONE ctermbg=NONE
  highlight Comment guifg=#728083
  highlight LineNr guifg=#728083
endfunction

augroup user_theme_overrides
  autocmd!
  autocmd ColorScheme * call <SID>ApplyThemeOverrides()
augroup END

colorscheme gruvbox
call s:ApplyThemeOverrides()

" Disable automatic comments on new lines.
augroup user_formatoptions
  autocmd!
  autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
augroup END

vnoremap <C-r> "hy:%s/<C-r>h//gc<left><left><left>

" Close buffer without exiting Neovim
nnoremap <silent> <leader>bd :bp \| sp \| bn \| bd<CR>

" Clear search highlight (and redraw) with Esc, since 'hlsearch' keeps
" matches highlighted after a / or ? search until :nohlsearch is called.
" Only bound in Normal mode, so it never touches Insert/Terminal popups.
nnoremap <silent> <Esc> :nohlsearch<Bar>:echo<CR><C-l>

" Load plugin settings.
for s:config_file in glob(stdpath('config') . '/configs/*.vim', 0, 1)
  execute 'source ' . fnameescape(s:config_file)
endfor
