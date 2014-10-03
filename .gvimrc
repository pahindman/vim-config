" GUI Specific VIM settings
" HINT: Type zR if you don't know how to use folds

"set autochdir

" Set GUI look-and-feel options {{{

set guifont=Inconsolata:h13,ProggySquareSZ:h15,Dina:h7

if has("unix")
   " Set gui parameters : These settings should be in .gvimrc !!!
   "set guifont=-schumacher-clean-medium-r-normal-*-*-120-*-*-c-*-iso646.1991-irv
   set guifont=-cronyx-fixed-medium-r-semicondensed-*-*-120-*-*-c-*-koi8-r
elseif has("macunix")
   set guifont=-cronyx-fixed-medium-r-semicondensed-*-*-120-*-*-c-*-koi8-r
else
   set guifont=ProggySquareSZ:h11,Dina:h7
   set guifont=ProggySquareSZ:h11,Dina:h7
   "set guifont=Lucida_Console:h9:w5:b
endif

" Hide the mouse when typing text
set mousehide
set lines=60
set columns=120
set guioptions=agrbm
set browsedir=buffer
if &diff
   set columns=180
   set diffopt=filler,iwhite
endif

"}}}

" vim:ft=vim:fdm=marker:ff=unix
