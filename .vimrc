" General VIM options (non-GUI)
" See .gvimrc or _gvimrc for the GUI specific options
" HINT: Type zR if you don't know how to use folds

set nocompatible

if has('win32') || has('win64')
    set rtp^=~/.vim
endif

" Auto-reload .[g]vimrc
augroup reload_vimrc " {
    autocmd!
    autocmd BufWritePost $MYVIMRC source $MYVIMRC
    autocmd BufWritePost $MYGVIMRC source $MYGVIMRC
augroup END " }

   " Set window look-and-feel options {{{

   " Always show a status line for the window
   set laststatus=2
   " Put the ruler info in status line (line #, column #, and file %)
   set ruler
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
   " Number of lines of context to keep below (or above) the cursor when
   " scrolling down (or up).
   "set scrolloff=5
   "set sidescroll=5
   "set sidescrolloff=5

   "}}}


   " Set tab & indent options {{{

   " Tabs count for 3 spaces
   set tabstop=3
   " Insert spaces when the tab key is pressed
   set expandtab
   " Shifting / (auto)indenting levels are in increments of 3 spaces
   set shiftwidth=3
   " When shifting lines L or R (e.g. using '<' or '>'), round to the nearest
   " 'shiftwidth' multiple
   set shiftround
   set smarttab
   set formatoptions+=cql2
   set textwidth=78

   " Automatically indent when typing a new line - also useful when formatting
   " blocks of text, e.g. with 'gq'.  Overridden by smartindent / cindent in
   " many contexts (TODO: delete - superceded by cindent?)
   set autoindent
   " Set smartindent feature (TODO: delete - superceded by cindent?)
   set smartindent

   " Automatic indenting for C-like languages
   set cindent
   set cino=>s,e0,n0,f0,{0,}0,^0,:s,=s,ps,t0,c3,+s,(s,us,)20,*30,gs,hs
   set cinkeys=0{,0},:,!^F,o,O,e

   "}}}


   " Set miscellaneous options {{{

   " Allow backspacing over everything in insert mode
   set backspace=indent,eol,start
   " Keep buffer loaded but 'hidden' when it is not visible in any windows
   set hidden
   set history=100

   " By default, ignore case when searching
   set ignorecase
   " When the search pattern is mixed-case, then do a case-sensitive search
   set smartcase
   " Highlight the search results
   set hlsearch
   " Show search results as the pattern is being typed
   set incsearch

   " use clipboard as the * register
   set clipboard=autoselect

   " setting wildchar expansion
   set wildmenu

   " Set Exuberant CTAGS file locations
   set tags=tags;

   "}}}


   " Set global key mappings {{{
   mapclear

   " Make p in Visual mode replace the selected text with the "" register.
   vnoremap p <Esc>:let current_reg = @"<CR>gvs<C-R>=current_reg<CR><Esc>

   " Keys to move around to different windows
   map <Esc>l l
   map <Esc>h h
   map <Esc>k k
   map <Esc>j j

   " Keys to switch which buffer is shown in current window
   map <Esc><Right> :bnext<CR>
   map <Esc><Left>  :bprevious<CR>
   "map <Esc><Up>    :brewind<CR>
   "map <Esc><Down>  :blast<CR>

   map Ν :bnext<CR>       " <M-Right>
   map Λ :bprevious<CR>   " <M-Left>
   "map Θ :brewind<CR>     " <M-Up>
   "map Π :blast<CR>       " <M-Down>

   " Keys to move to the next/previous error in a list of errors
   map <Esc>n :cn<CR>
   map <Esc>p :cp<CR>

   " Keys to grep for the word under cursor
   map <Esc>8 :grep -r <cword> *<CR>
   map <Esc><Esc>8 :grep -r -w <cword> *<CR>

   " perforce stuff
   nmap ,pl :!p4 login<CR>
   nmap ,pa :!p4 add "%"<CR>
   nmap ,pe :!p4 edit "%"<CR>:e!<CR>
   nmap ,pr :!p4 revert "%"<CR>:e!<CR>
   nmap ,ps :!p4 sync "%"<CR>:e!<CR>
   nmap ,pu :!p4 submit<CR>:e!<CR>
   nmap ,pb :call PerforceBlame()

   " Opening a Vim Explorer Window
   nnoremap <Esc>e :Exp<CR>

   " easy editing
   if has("unix") || has("macunix")
      map ,e :e <C-R>=expand("%:p:h")."/"<CR>
   else
      map ,e :e <C-R>=expand("%:p:h")."\\"<CR>
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


   " Set platform specific shell options {{{
   if has("unix") || has("macunix")
      set viminfo='32,n/tmp/viminfo
      set shell=/bin/bash
      set grepprg=grep\ -n
      set directory=/tmp
   else
      set viminfo='32,n$TMP/viminfo
      " I found that in order for the perforce plugin to work right, this
      " needs to be the shell...
      set shell=$windir\system32\cmd.exe
      set grepprg=c:\tools\grep.exe\ -n
      set directory=$TMP
      source $VIMRUNTIME/mswin.vim  " See :help mswin.vim
   endif
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
      \     exe "normal m`"  |
      \     :%s/[[:space:]\r]\+$//e  |
      \     exe "noh"        |
      \     exe "normal g``" |
      \  endif

      " When editing a file, always jump to the last known cursor position.
      " Don't do it when the position is invalid or when inside an event handler
      " (happens when dropping a file on gvim).
      autocmd BufReadPost *
      \  if line("'\"") > 0 && line("'\"") <= line("$") |
      \     exe "normal g`\"" |
      \  endif

   endif
   "}}}


   " Set syntax highlighting options {{{
   syntax clear
   set background=dark
   syntax enable
   "}}}


   " Set colors for syntax highlighting {{{

   hi StatusLine     term=bold,reverse cterm=bold  ctermfg=lightblue ctermbg=white  gui=bold guifg=white    guibg=blue
   hi StatusLineNC   term=bold,reverse cterm=bold  ctermfg=lightblue ctermbg=white  gui=bold guifg=darkgray guibg=blue
   hi ErrorMsg       term=standout     cterm=bold  ctermfg=grey      ctermbg=blue   gui=bold guifg=black    guibg=red
   hi WarningMsg     term=standout     cterm=bold  ctermfg=darkred                  gui=bold guifg=red      guibg=black

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

   " Try colorschemes in reverse order of preference
   silent! colorscheme BlackBeauty

   " For now only use solarized on Linux and MacOS X - on Windows with the
   " default color mappings it looks really ugly
   if has("unix") || has("macunix")
      silent! colorscheme solarized
   endif
   syntax enable

   "}}}


   " Configure 'miniBufExplorer' plugin + key mappings + MBE highlighting {{{
   let g:miniBufExplCheckDupeBufs = 0
   let g:miniBufExplSplitBelow = 0
   "let g:miniBufExplMapCTabSwitchBufs = 1
   "let g:miniBufExplMapWindowNavArrows = 1
   let g:miniBufExplShowUnnamedBuffers = 1
   let g:miniBufExplModSelTarget = 1
   let g:miniBufExplUseSingleClick = 1
   let g:miniBufExplTabWrap = 1
   let g:miniBufExplorerDebugMode  = 3
   let g:miniBufExplorerDebugLevel = 0
   nnoremap <silent> <xF3> :MBEToggle<CR>
   nnoremap <silent> <F3>  :MBEToggle<CR>

   hi link MBENormal                Normal
   hi link MBEChanged               WarningMsg
   hi link MBEVisibleNormal         Comment
   hi link MBEVisibleActive         Visual
   hi link MBEVisibleChanged        WarningMsg
   hi      MBEVisibleChangedActive  term=standout ctermfg=Red ctermbg=Grey guifg=Red guibg=Grey
   "}}}

" vim:ft=vim:fdm=marker:ff=unix
