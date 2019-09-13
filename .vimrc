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
Plugin 'bling/vim-bufferline'
Plugin 'mbbill/undotree'
Plugin 'tomtom/tcomment_vim'
Plugin 'LaTex-Box-Team/LaTex-Box'
Plugin 'easymotion/vim-easymotion'
Plugin 'kien/ctrlp.vim'
Plugin 'severin-lemaignan/vim-minimap'
Plugin 'pseewald/vim-anyfold'
Plugin 'mileszs/ack.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'majutsushi/tagbar'
Plugin 'junegunn/vim-easy-align'

call vundle#end()
filetype plugin indent on

" Undotree
" <Leader>u shortcut works only in normal mode
nnoremap <Leader>u :UndotreeToggle<CR>
let g:undotree_SplitWidth = 40
let g:undotree_DiffpanelHeight = 15
let g:undotree_SetFocusWhenToggle = 1

" Latexbox
autocmd Filetype tex let g:LatexBox_latexmk_async = 0
autocmd Filetype tex nnoremap <buffer> <Leader>lm :Latexmk<CR>
autocmd Filetype tex nnoremap <buffer> <F5> :Latexmk<CR>
autocmd Filetype tex nnoremap <buffer> <Leader>lv :LatexView<CR>
autocmd Filetype tex nnoremap <buffer> <Leader>le :LatexErrors<CR>

" Easy Motion plugin
" Enable default mappings
let g:EasyMotion_do_mapping = 1

" Turn on case insensitive feature
let g:EasyMotion_smartcase = 1

" CtrlP
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
nnoremap <S-T> :CtrlPTag<cr>

" Vim Anyfold
let anyfold_activate = 1
set foldlevel=5

" Vim Ack
let g:ack_default_options = " -sH --smart-case"
let g:ackhighlight = 1
nmap <leader>f :Ack! ""<Left>
nmap <leader>F :Ack! <C-r><C-w><CR>

" NERDTree
nmap <Leader>b :NERDTreeToggle<CR>
nmap <c-b> :NERDTreeToggle <CR>
let g:NERDTreeDirArrows=0

" Tagbar
nmap <Leader>t :TagbarToggle<CR>
let g:tagbar_type_vhdl = {
	\ 'ctagstype': 'vhdl',
	\ 'kinds' : [
		\'d:prototypes',
		\'b:package bodies',
		\'e:entities',
		\'a:architectures',
		\'t:types',
		\'p:processes',
		\'f:functions',
		\'r:procedures',
		\'c:constants',
		\'T:subtypes',
		\'r:records',
		\'C:components',
		\'P:packages',
		\'l:locals'
	\]
\}

" Vim easy align
nmap ga <Plug>(EasyAlign)
xmap ga <Plug>(EasyAlign)

" Vundle End

" enable syntax processing
syntax on
colorscheme desert

" The line numbering is tooo bright and flashy. Turn it to gray
hi LineNr guibg=grey15 guifg=grey ctermbg=235 ctermfg=102
hi CursorLineNr guibg=grey15 ctermbg=235

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

" It’s quite annoying after you search smething, the highlight
" just stays on, press F3 to change this
nnoremap <F3> :let @/ = ""<CR>

" Will allow doing :w!! to write to a file using sudo if forgot to sudo
" vim file (it will prompt for sudo password when writing)
" stackoverflow.com/questions/95072/what-are-your-favourite-vim-tricks/96492#96492
cmap w!! %!sudo tee > /dev/null %
cmap W!! %!sudo tee > /dev/null %

" Python necessity: Shortcut to execute the script
autocmd Filetype python nnoremap <F5> :w! \| !python %<CR>

" Cannot use left up right down keys hehe!
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>

inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>

" Change highlig" Highlight the current line as a gray something line
" because macVim looks terrible without these setting
set cursorline
hi CursorLine cterm=NONE ctermbg=235 guibg=gray15
hi NonText guibg=black ctermbg=0
hi Normal guibg=black ctermbg=0

" Map buffer shortcuts
nnoremap <Leader><Tab> :bnext<CR>
nnoremap <Leader><S-Tab> :bprevious<CR>

" When switching between buffers, do not forget the undotree history
set hidden

" Highlight column 80 in a gray line. Press F6
if v:version >= 703

function! Toggle80ColShow ()
	if &cc=="80,".join(range(120,999),",")
		let &cc="".join(range(120,999),",")
	else
		let &cc="80,".join(range(120,999),",")
	endif
endfunction

let &cc="".join(range(120,999),",")
hi ColorColumn ctermbg=235 ctermfg=NONE guibg=gray15
nnoremap <F6> :silent call Toggle80ColShow()<CR>

endif

function CountNumberOfBuffers ()
	let cnt = 0
	for nr in range (1, bufnr("$"))
		if buflisted(nr) && !empty(bufname(nr))
			let cnt += 1
		endif
	endfor
	return cnt
endfunction

function ForceQuitIfLastBuffer ()
	if CountNumberOfBuffers() == 1
		:q!
	else
		:bd!
	endif
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
nnoremap :Q<CR> :call QuitIfLastBuffer()<CR>
nnoremap :q!<CR> :call ForceQuitIfLastBuffer()<CR>
nnoremap :wq<CR> :call SaveAndQuitIfLastBuffer()<CR>
nnoremap :Wq<CR> :call SaveAndQuitIfLastBuffer()<CR>
nnoremap :WQ<CR> :call SaveAndQuitIfLastBuffer()<CR>

highlight ExtraWhitespace ctermbg=darkred guibg=darkred
match ExtraWhitespace /\s\+$/

" Diff against disk <-- very usefull ^^. Just do `<space> d` in your vim
map <silent> <Leader>d :call DC_DiffChanges()<CR>

" Change the fold marker to something more useful
function! DC_LineNumberOnly ()
	if v:foldstart == 1
		return '(No difference)'
	else
		return 'line ' . v:foldstart . ':'
	endif
endfunction

" Track each buffer's initial state
augroup DC_TrackInitial
	autocmd!
	autocmd BufReadPost,BufNewFile  *   if !exists('b:DC_initial_state')
	autocmd BufReadPost,BufNewFile  *       let b:DC_initial_state = getline(1,'$')
	autocmd BufReadPost,BufNewFile  *   endif
augroup END

function! DC_DiffChanges ()
	diffthis
	highlight Normal ctermfg=grey
	let initial_state = b:DC_initial_state
	set diffopt=context:1000000,filler,foldcolumn:0
	set fillchars=fold:\
	set foldcolumn=0
	setlocal foldtext=DC_LineNumberOnly()
	aboveleft vnew
	normal 0
	silent call setline(1, initial_state)
	diffthis
	set nocursorline
	set diffopt=context:1000000,filler,foldcolumn:0
	set fillchars=fold:\
	set foldcolumn=0
	setlocal foldtext=DC_LineNumberOnly()
	nmap <silent><buffer> <Leader>d :diffoff<CR>:q!<CR>:set diffopt& fillchars& foldcolumn=0<CR>:set nodiff<CR>:highlight Normal ctermfg=NONE<CR>
endfunction

" Normal backspacing
set backspace=indent,eol,start

" Allow shift backspace
noremap! <C-?> <C-h>

