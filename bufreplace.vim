"---------------------------------------------------------------------------
"" Search for <cword> and replace with input() in all open buffers
"---------------------------------------------------------------------------
"
fun! Replace()
    let s:word = input("Replace " . expand('<cword>') . " with:")
    :exe 'bufdo! %s/' . expand('<cword>') . '/' . s:word . '/ge'
    :unlet! s:word
endfun

map \r :call Replace()<CR>
