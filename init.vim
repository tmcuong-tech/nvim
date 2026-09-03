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
set number		    " Show line number
set relativenumber
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
set updatetime=300          " Faster Coc diagnostics and CursorHold
set signcolumn=yes          " Avoid text shifting when diagnostics appear
set encoding=utf-8
let mapleader = ' '

" Disable backup
set nobackup
set nowb
set noswapfile

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
  Plug 'morhetz/gruvbox'
  Plug 'joshdick/onedark.vim'
  Plug 'folke/tokyonight.nvim'

  " Status bar
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
  Plug 'nvim-tree/nvim-web-devicons'            " Icons

  " File browser
  Plug 'preservim/nerdTree'                     " File browser  
  Plug 'Xuyuanp/nerdtree-git-plugin'            " Git status
  Plug 'ryanoasis/vim-devicons'                 " Icon
  Plug 'unkiwii/vim-nerdtree-sync'              " Sync current file 
  Plug 'jcharum/vim-nerdtree-syntax-highlight',
    \ {'branch': 'escape-keys'}
  
  " File search
  Plug 'junegunn/fzf', 
    \ { 'do': { -> fzf#install() } }            " Fuzzy finder 
  Plug 'junegunn/fzf.vim'

  " Terminal
  Plug 'voldikss/vim-floaterm'                  " Float terminal

  " Code Intellisense / Completion (covers C/C++, Python, Java, Rust, Bash via extensions)
  Plug 'neoclide/coc.nvim', {'branch': 'release'}

  " Native LSP management (Assembly, Lua and Go in configs/lsp.vim)
  Plug 'neovim/nvim-lspconfig'
  Plug 'mason-org/mason.nvim'
  Plug 'mason-org/mason-lspconfig.nvim'

  " Code syntax highlight
  Plug 'sheerun/vim-polyglot'

  " Debugging
  Plug 'puremourning/vimspector'                " Vimspector

  " Source code version control 
  Plug 'tpope/vim-fugitive'                     " Git infomation 
  Plug 'tpope/vim-rhubarb' 
  Plug 'airblade/vim-gitgutter'                 " Git show changes 
  Plug 'samoshkin/vim-mergetool'                " Git merge

  " Fold 
  Plug 'tmhedberg/SimpylFold'

  " Editing helpers
  Plug 'jiangmiao/auto-pairs'                   " Parenthesis auto
  Plug 'mattn/emmet-vim'                        " HTML/CSS abbreviation
  Plug 'preservim/nerdcommenter'                " Comment code

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

" Load plugin settings.
for s:config_file in glob(stdpath('config') . '/configs/*.vim', 0, 1)
  execute 'source ' . fnameescape(s:config_file)
endfor
