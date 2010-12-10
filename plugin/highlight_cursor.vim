" This does not work the way I'd expect; it highlights the _first_ line of the
" file, always. Yet calling ':set cul' will correctly highlight the current
" line.
function! Highlight_Cursor ()
    set cursorline
    redraw
    sleep 1
    set nocursorline
endfunction
" autocmd     FocusGained     *   :call Highlight_Cursor()
" autocmd     BufEnter        *   :call Highlight_Cursor()
