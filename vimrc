set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

Plugin 'tpope/vim-surround'
Plugin 'raimondi/delimitmate'
Plugin 'bling/vim-airline'
Plugin 'scrooloose/nerdcommenter'

Plugin 'good5dog5/arm.vim'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" Put your non-Plugin stuff after this line

"this is needed for airline to work properly
set laststatus=2

"for unicode support
set encoding=utf-8

"from msu cse320
"Use 80 as the width of one line and wrap long lines
set textwidth=80
set wrap
highlight ColorColumn ctermbg=DarkGray
set colorcolumn=81

" Enable syntax highlighting
syntax on
set number 

" Enable C/C++ indenting
set cindent

" Expand tabs into 2 spaces (except for makefiles)
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
autocmd FileType  make      setlocal noexpandtab
autocmd FileType  makefile  setlocal noexpandtab

" set the leader to the space bar
set showcmd
let mapleader = ","
