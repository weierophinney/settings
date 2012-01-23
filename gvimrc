:colorscheme solarized
" :colorscheme koehler
" :set guifont=DejaVu\ Sans\ Mono\ Book\ 11
" :set guifont=Droid\ Sans\ Mono\ 10
:set guifont=Anonymous\ Pro\ for\ Powerline\ 12
" :set guifont=Ubuntu\ Mono\ for\ Powerline\ 12
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

" In gvim, we can safely use the 'fancy' Powerline symbols
let g:Powerline_symbols="fancy"
let g:Powerline_cache_file="/home/matthew/tmp/Powerline-gvim.cache"
