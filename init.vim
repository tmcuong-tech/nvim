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
" Disable backup
set nobackup
set nowb
set noswapfile
" Optimize 
set synmaxcol=3000    "Prevent breaking syntax hightlight when string too long. Max = 3000"
set lazyredraw
set updatetime=300          " Faster CursorHold / gitgutter / coc diagnostics
set signcolumn=yes           " Always show sign column (avoid text shifting for git/coc signs)
set encoding=UTF-8
let mapleader = ' '
 
" => Plugin list
" (used with Vim-plug - https://github.com/junegunn/vim-plug)
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

  " Native LSP for Assembly (coc has no good asm support; asm-lsp is used directly via nvim-lspconfig)
  Plug 'neovim/nvim-lspconfig'

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

" => Plugin setttings
" Source individual plugin config files
for s:cfg in glob(stdpath('config') . '/configs/*.vim', 0, 1)
  execute 'source' s:cfg
endfor
 
