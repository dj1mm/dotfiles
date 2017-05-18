
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
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'

Plugin 'bling/vim-airline'
Plugin 'tpope/vim-surround'
Plugin 'mhinz/vim-signify'
Plugin 'bling/vim-bufferline'
Plugin 'mbbill/undotree'
Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'
Plugin 'tomtom/tcomment_vim'
Plugin 'LaTex-Box-Team/LaTex-Box'
Plugin 'easymotion/vim-easymotion'
Plugin 'Valloric/YouCompleteMe'
Plugin 'kien/ctrlp.vim'

call vundle#end()
filetype plugin indent on

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

" Python necessity: Shortcut to execute the script
noremap <Leader>px :w! \| !python %<CR>

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

" Map buffer shortcuts
nnoremap <Leader><Tab> :bnext<CR>
nnoremap <Leader><S-Tab> :bprevious<CR>

" When switching between buffers, do not forget the undotree history
set hidden

" Highlight column 80 in a gray line. Press F6
if v:version >= 703

function! Toggle80ColShow ()
	if &cc==80
		set cc=0
	else
		set cc=80
	endif
endfunction

hi ColorColumn ctermbg=233 ctermfg=NONE guibg=233
nnoremap <F6> :silent call Toggle80ColShow()<CR>

endif

" Highlight the current line as a gray something line
set cursorline
hi cursorline ctermbg=232 guibg=232

function CountNumberOfBuffers ()
	let cnt = 0
	for nr in range (1, bufnr("$"))
		if buflisted(nr) && !empty(bufname(nr))
			let cnt += 1
		endif
	endfor
	return cnt
endfunction

function QuitIfLastBuffer ()
	if CountNumberOfBuffers() == 1
		:q
	else
		:bd
	endif
endfunction

function SaveAndQuitIfLastBuffer ()
	if CountNumberOfBuffers() == 1
		:wq
	else
		:w
		:bd
	endif
endfunction

nnoremap :q<CR> :call QuitIfLastBuffer()<CR>
nnoremap :wq<CR> :call SaveAndQuitIfLastBuffer()<CR>

highlight ExtraWhitespace ctermbg=darkred guibg=darkred
match ExtraWhitespace /\s\+$/
