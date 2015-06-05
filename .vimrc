" ---------------------------------------------------
"  My .vimrc
"  inspired from dougblack.io/words/a-good-vimrc.html
" ---------------------------------------------------

execute pathogen#infect()
filetype plugin indent on

" enable syntax processing
syntax on
colorscheme desert

" show line number
set number
set autoindent

" sets the shiftwidth and the tabwidth to 4
set sw=4
set tabstop=4

" show the last command and the --INSERT-- or --VISUAL-- text
set showcmd
set showmode

" Searching
" search as characters are entered but do not highlight them continuously
set incsearch
set nohlsearch

" Shows the status bar of file
set laststatus=2
set ruler
