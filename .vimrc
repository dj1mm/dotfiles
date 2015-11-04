" ---------------------------------------------------
"  My .vimrc
"  inspired from dougblack.io/words/a-good-vimrc.html
" ---------------------------------------------------

" Leader button is now <Space>. Put it here so that easymotion leader is 
" oso <Space>.
let mapleader="\<Space>"

" Vundle configurations
set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
set rtp+=~/.vim/bundle/ctrlp.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'

Plugin 'bling/vim-airline'
Plugin 'tpope/vim-surround'
Plugin 'mhinz/vim-signify'
Plugin 'bling/vim-bufferline'
Plugin 'Valloric/YouCompleteMe'
Plugin 'mbbill/undotree'
Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'
Plugin 'tomtom/tcomment_vim'
Plugin 'LaTex-Box-Team/LaTex-Box'
Plugin 'easymotion/vim-easymotion'

call vundle#end()
filetype plugin indent on

" YouCompleteMe plugin configurations
let g:ycm_global_ycm_extra_conf = '~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'

" Undotree
nnoremap <F5> :UndotreeToggle<CR>
let g:undotree_SplitWidth = 40
let g:undotree_DiffpanelHeight = 15
let g:undotree_SetFocusWhenToggle = 1

" Ultisnips
let g:UltiSnipsExpandTrigger = '<c-j>'
let g:UltiSnipsJumpForwardTrigger = '<c-j>'
let g:UltiSnipsJumpBackwardTrigger = '<c-k>'

" Latexbox
let g:LatexBox_latexmk_async = 0
noremap <Leader>lm :Latexmk<CR>
noremap <Leader>lv :LatexView<CR>
noremap <Leader>le :LatexErrors<CR>

" Easy Motion plugin
" Enable default mappings
let g:EasyMotion_do_mapping = 1

" Turn on case insensitive feature
let g:EasyMotion_smartcase = 1

" Vundle End

let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'

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
" search as characters are entered and highlight them continuously
set incsearch
set hlsearch

" Search using regexp
set magic

" Shows the status bar of file and the cursor position
set laststatus=2
set ruler

" Can use mouse to navigate in the vim document
set mouse=a

" Some mapping and remapping
command Q q
command W w
command WQ wq
command Wq wq

" Its quite annoying after you search smething, the highlight
" just stays on, press F3 to change this
nnoremap <F3> :let @/ = ""<CR>

" Will allow doing :w!! to write to a file using sudo if forgot to sudo
" vim file (it will prompt for sudo password when writing)
" stackoverflow.com/questions/95072/what-are-your-favourite-vim-tricks/96492#96492
cmap w!! %!sudo tee > /dev/null %
cmap W!! %!sudo tee > /dev/null %

" Cannot use left up right down keys hehe!
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>

inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>

" Change highlighting because macVim looks terrible without
" these setting
hi CursorLine cterm=NONE ctermbg=236
hi NonText guibg=black
hi Normal guibg=black
