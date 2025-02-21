" General VIM options (non-GUI)
" See .gvimrc or _gvimrc for the GUI specific options
" HINT: Type zR if you don't know how to use folds

set nocompatible

if has('win32') || has('win64')
	set rtp^=~/.vim
endif

try
	let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
	if empty(glob(data_dir . '/autoload/plug.vim'))
		silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
		autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
	endif

	call plug#begin()

	Plug 'ericbn/vim-solarized'
	Plug 'junegunn/fzf.vim'
	Plug 'junegunn/fzf'
	Plug 'junegunn/vim-peekaboo'
	Plug 'junegunn/vim-plug'
	Plug 'rust-lang/rust.vim'
	Plug 'shumphrey/fugitive-gitlab.vim'
	Plug 'tpope/vim-commentary'
	Plug 'tpope/vim-dispatch'
	Plug 'tpope/vim-fugitive'
	Plug 'tpope/vim-obsession'
	Plug 'tpope/vim-repeat'
	Plug 'tpope/vim-rhubarb'
	Plug 'tpope/vim-sensible'
	Plug 'tpope/vim-surround'
	Plug 'tpope/vim-unimpaired'
	Plug 'vim-airline/vim-airline'
	Plug 'vim-airline/vim-airline-themes'
	Plug 'weynhamz/vim-plugin-minibufexpl'

	if has('nvim-0.6') || has('patch-9.0.0185')
		Plug 'github/copilot.vim'
	endif
	if has('nvim-0.8')
		Plug 'neovim/nvim-lspconfig'
	endif
	if has('nvim-0.10')
		Plug 'nvim-lua/plenary.nvim'
		Plug 'nvim-treesitter/nvim-treesitter'
		Plug 'olimorris/codecompanion.nvim'
	endif

	call plug#end()
catch
	echom "Couldn't use Vim-Plug, install it?"
endtry

let g:airline_symbols_ascii = 1
let g:airline#extensions#obsession#enabled = 1

" Auto-reload .[g]vimrc
augroup reload_vimrc " {
	autocmd!
	autocmd BufWritePost $MYVIMRC source $MYVIMRC
	autocmd BufWritePost $MYGVIMRC source $MYGVIMRC
augroup END " }

" Function to source only if file exists {
function! SourceIfExists(file)
	if filereadable(expand(a:file))
		exe 'source' a:file
	endif
endfunction
" }

" Set window look-and-feel options {{{

" Show information about commands that are in the process of being entered
" - useful visual feedback for complex commands, and for Visual mode info
set showcmd
" When a brace is inserted, highlight the corresponding matching brace.
set showmatch
" Display message when Vim is in Insert, Replace, or Visual mode
set showmode
" Do not wrap long lines on the display
set nowrap
" When a new window is split, put it below the current window
set splitbelow
" Highlight the current line
set cursorline

"}}}


" Set tab & indent options {{{

" Tabs count for 4 spaces
set tabstop=4
" Insert a Tab character (not spaces) when the tab key is pressed
set noexpandtab
" Shifting / (auto)indenting levels are in increments of 4 spaces
set shiftwidth=4
" When shifting lines L or R (e.g. using '<' or '>'), round to the nearest
" 'shiftwidth' multiple
set shiftround
set formatoptions+=cqlnj
set textwidth=90

set listchars+=tab:>-

" Options for cindent
" Don't indent a return type that is on its own line
set cinoptions+=t0
" Make lines inside unclosed parenthesis line up with the character after
" the opening parenthesis
set cinoptions+=(0
" Don't force #words to start in first column
set cinkeys-=0#

"}}}


" Set miscellaneous options {{{

" Keep buffer loaded but 'hidden' when it is not visible in any windows
set hidden

" By default, ignore case when searching
set ignorecase
" When the search pattern is mixed-case, then do a case-sensitive search
set smartcase
" Highlight the search results
set hlsearch

" use clipboard as the * register
set clipboard=unnamedplus

if !has('nvim')
	if executable('rg')
		set grepprg=rg\ --vimgrep\ -uu
	else
		set grepprg=grep\ -nH\ $*
	endif
endif
"}}}


" Set global key mappings {{{
mapclear

" Set the <Leader> to <Spc>
let mapleader=" "

" Keys to grep for the word under cursor
map <Leader>8 :grep -r <cword> *<CR>
map <Leader><Leader>8 :grep -r -w <cword> *<CR>

if has('nvim-0.8')
	nnoremap <buffer> <silent> <leader>dq <cmd>lua vim.diagnostic.setloclist()<CR>
endif

" easy editing
if has("unix") || has("macunix")
	map <Leader>e :e <C-R>=expand("%:p:h")."/"<CR>
else
	map <Leader>e :e <C-R>=expand("%:p:h")."\\"<CR>
endif

" Make the Home key toggle between the first character on a line,
" and the first non-whitespace character on a line.
" See http://www.vim.org/tips/tip.php?tip_id=315
fun! s:SmartHome()
	" this line checks if we are not on the first whitespace.
	if col('.') != match(getline('.'), '\S')+1
		norm ^
	else
		norm 0
	endif
endfun

inoremap <silent><home> <C-O>:call <SID>SmartHome()<CR>
nnoremap <silent><home> :call <SID>SmartHome()<CR>
vnoremap <silent><home> :call <SID>SmartHome()<CR>

"}}}


" Set autocmd options {{{
if has("autocmd")
	" Remove all autocommands in case this file is sourced
	autocmd!

	" Enable file type detection.
	" Use the default filetype settings, so that mail gets 'tw' set to 72,
	" 'cindent' is on in C files, etc.
	" Also load indent files, to automatically do language-dependent indenting.
	filetype plugin indent on

	" Automatically remove trailing whitespace and \r when saving, but only if the
	" buffer isn't binary
	autocmd BufWritePre *
	\  if( getbufvar(bufnr('%'), '&binary') == "nobinary" ) |
	\		exe "normal m`"  |
	\		:%s/[[:space:]\r]\+$//e  |
	\		exe "noh"		 |
	\		exe "normal g``" |
	\  endif

	" When editing a file, always jump to the last known cursor position.
	" Don't do it when the position is invalid or when inside an event handler
	" (happens when dropping a file on gvim).
	autocmd BufReadPost *
	\  if line("'\"") > 0 && line("'\"") <= line("$") |
	\		exe "normal g`\"" |
	\  endif

endif
"}}}


" Set syntax highlighting options {{{
syntax clear
set background=dark
set termguicolors
"}}}


" Set colors for syntax highlighting {{{

hi StatusLine	 term=bold,reverse cterm=bold  ctermfg=lightblue ctermbg=white	gui=bold guifg=white	guibg=blue
hi StatusLineNC	 term=bold,reverse cterm=bold  ctermfg=lightblue ctermbg=white	gui=bold guifg=darkgray guibg=blue
hi ErrorMsg		 term=standout	   cterm=bold  ctermfg=grey		 ctermbg=blue	gui=bold guifg=black	guibg=red
hi WarningMsg	 term=standout	   cterm=bold  ctermfg=darkred					gui=bold guifg=red		guibg=black

hi clear String
hi link String Constant
hi clear Number
hi link Number Constant

hi clear SpecialKey
hi SpecialKey	  term=bold  cterm=bold  ctermfg=darkred  guifg=Red
hi clear NonText
hi NonText		  term=bold  cterm=bold  ctermfg=darkred  gui=bold	guifg=Red
hi clear Directory
hi Directory	  term=bold  cterm=bold  ctermfg=brown	guifg=Red

silent! colorscheme solarized
syntax enable

"}}}


" Configure 'miniBufExplorer' plugin + key mappings + MBE highlighting {{{
let g:miniBufExplBRSplit= 0
let g:miniBufExplUseSingleClick = 1
let g:miniBufExplTabWrap = 1
let g:miniBufExplDebugMode = 3
let g:miniBufExplDebugLevel = 0
nnoremap <silent> <xF3> :MBEToggle<CR>
nnoremap <silent> <F3>  :MBEToggle<CR>

hi link MBENormal               Normal
hi link MBEChanged              WarningMsg
hi link MBEVisibleNormal        Comment
hi link MBEVisibleActive        Visual
hi link MBEVisibleChanged       WarningMsg
hi      MBEVisibleChangedActive term=standout ctermfg=Red ctermbg=Grey guifg=Red guibg=Grey
"}}}


" Configure rust plugin {{{
let g:rustfmt_autosave = 1
"}}}


" Configure fzf plugin {{{
let g:fzf_command_prefix = 'Fzf'
let g:fzf_layout = { 'tmux': '-p70%,60%', 'window': { 'width': 0.7, 'height': 0.6, 'relative': v:true } }
"}}}

call SourceIfExists("~/.vimrc.local")

" vim:ft=vim:fdm=marker
