" Basic UI Changes
syntax enable

" Use system clipboard
set clipboard=unnamed

set autoindent expandtab tabstop=2 shiftwidth=2

" Plugins (skip silently if vim-plug isn't installed yet — install.sh handles it)
if !empty(glob(stdpath('data') . '/site/autoload/plug.vim'))
  call plug#begin()
  Plug 'tpope/vim-sensible'
  Plug 'keith/swift.vim'
  Plug 'toyamarinyon/vim-swift'
  Plug 'tpope/vim-commentary'
  call plug#end()
endif
