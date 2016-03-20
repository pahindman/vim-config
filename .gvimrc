" GUI Specific VIM settings
" HINT: Type zR if you don't know how to use folds

" Set GUI look-and-feel options {{{

set guifont=Inconsolata:h13,ProggySquareSZ:h15,Consolas
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

" vim:ft=vim:fdm=marker
