:colorscheme koehler
:set guifont=Anonymous\ Pro\ 12
" :set guifont=Monospace\ 11
" :set guifont=Andale\ Mono\ 11
" :set guifont=Courier\ 10\ Pitch\ 11
:set lines=24
:set columns=80

" Power mgmt savings -- turn off blinking cursor
let &guicursor = &guicursor . ",a:blinkon0"

" Do not display Toolbar or menus
:set go-=T
:set go-=m
