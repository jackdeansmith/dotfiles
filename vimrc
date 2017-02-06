set nocompatible              " Required for Vundle
filetype off                  " Required for Vundle

"----------VUNDLE STUFF-----------
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

"My pulgins
Plugin 'tpope/vim-surround'
Plugin 'raimondi/delimitmate'
Plugin 'bling/vim-airline'
Plugin 'scrooloose/nerdcommenter'
Plugin 'good5dog5/arm.vim'
Plugin 'ervandew/supertab'
Plugin 'godlygeek/tabular'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

"this is needed for airline to work properly
set laststatus=2
"---------END VUNDLE STUFF----------

"Keybindings
let mapleader = " "

"Encoding
set enc=utf-8
set fenc=utf-8
set termencoding=utf-8

"Wildmode, just seeing if I'll actually use it, borrowed from another .vimrc
set wildmenu " turn on wild menu
set wildmode=list:longest " turn on wild menu in special format (long format)
set wildignore=*.dll,*.o,*.obj,*.bak,*.exe,*.pyc,*.swp,*.jpg,*.gif,*.png " ignore formats"

"Indentation
set cindent
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
autocmd FileType  make      setlocal noexpandtab
autocmd FileType  makefile  setlocal noexpandtab

"UI
set textwidth=80
set wrap
highlight ColorColumn ctermbg=DarkGray
set colorcolumn=81
set showcmd
syntax on
set number 
