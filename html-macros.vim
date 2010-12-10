" Vim filetype plugin
" Language:	HTML
" Maintainer: Carl Mueller, cmlr@math.rochester.edu
" Last Change:	December 3, 2001
" Version:  1.0
" Website:  http://www.math.rochester.edu/u/cmlr/vim/syntax/index.html
" This is an html mode.  Typing "<" produces "<>" with the cursor in
" between.  After that, you should be able to do everything else with the
" F1 key.  There are also Auctex style macros.  For example, ;1 inserts
" <h1></h1> with the cursor in between.  ;ta inserts <table></table> and
" ;td inserts <td></td>.

noremap <buffer> <C-K> :!netscape file:$PWD/% &<CR><Esc>

" Let % work with <...> pairs.
set matchpairs+=<:>

set autoindent
set shiftwidth=2
set smarttab
set smartindent

" In normal mode, F1 inserts a latex template.
noremap <buffer> <F1> :if strpart(getline(1),0,6) !~ "^<\[Hh]\[Tt]\[Mm]\[Ll]>"<CR>0read ~/.Vim/html-template.vim<CR>normal /<\/title\\|<\/TITLE<CR><CR>:endif<CR>3jf>a

" In insert mode, F1 looks back to find the last uncompleted <> tag, and
" inserts the completion.  It ignores uncompleted <hr>, <p>, <li>, <im..>,
" and their capitalized forms.  F2 does the same, but puts blank lines in
" between.
inoremap <buffer> <F1> <Esc>:call <SID>OneLineCompletion()<CR>i
inoremap <buffer> <F2> <Esc>:call <SID>ThreeLineCompletion()<CR>a
inoremap <buffer> <F3> <a href=""></a><Esc>5hi
inoremap <buffer> <F4> <a href="mailto:"></a><Esc>5hi
inoremap <buffer> <F5> <IMG src="" alt=""><Esc>8hi
inoremap <buffer> <M-c> <!--  --><Esc>3hi
inoremap <buffer> <M-h> <a href=""></a><Esc>5hi
inoremap <buffer> <M-i> <IMG src="" alt=""><Esc>8hi
inoremap <buffer> <M-m> <a href="mailto:"></a><Esc>5hi

" In visual mode, F1 encloses the selected region in
" a pair of <>...</> braces.
function! s:InsertTag(tag)
    exe "normal `>a\<C-V></" . a:tag . "\<C-V>>\<Esc>`<i<" . a:tag . "\<Esc>l"
endfunction

vnoremap <buffer> <F1> <C-C>:call <SID>InsertTag(input("HTML Tag? "))<CR>

" Another way to insert the tag:
inoremap <buffer> <C-F1> <Esc>:call <SID>PutInTag(input("Tag? "))<CR>

function! s:PutInTag(tag)
    exe "normal a<" . a:tag . "\<Esc>la</" . a:tag . "\<Esc>F<"
    startinsert
endfunction

inoremap <buffer> " <C-R>=<SID>Double('"','"')<CR>
function! s:Double(left,right)
    if strpart(getline(line(".")),col(".")-2,2) == a:left . a:right
	return "\<C-O>s"
    else
	return a:left . a:right . "\<Left>"
    endif
endfunction

" If you have just used F1 in visual mode to insert a pair of <>...</>
" braces, you can type in what goes in the first, and then F1 will complete
" it.

" This function sees whether you are inside a <...> and moves you to the >
" if you are.  Otherwise it stays where it is.  Then it completes the last
" unmatched <...>, excluding <p> and <br> and <li>.  If </p>, etc. are
" present, they will screw things up.

function! s:OneLineCompletion()
    let s:string = strpart(getline(line(".")),0,col("."))
    if s:string =~ "<\[^>]\*$"
	normal f>
    endif
    exe "normal v\<Esc>"
    call <SID>GoBackwardToTag()
    exe "normal ly/\\W\<CR>"
    exe "normal `<a</\<Esc>pF<"
endfunction

" This function is the same as the last, except it puts the matching
" </...> three lines down, if you are inside a <...>.

function! s:ThreeLineCompletion()
    let s:string = strpart(getline(line(".")),0,col("."))
    let s:inside = 0
    if s:string =~ "<\[^>]\*$"
	normal f>
	let s:inside = 1
    endif
    exe "normal v\<Esc>"
    call <SID>GoBackwardToTag()
    exe "normal ly/\\W\<CR>"
    if s:inside
	exe "normal `<a\<CR>\<CR></\<Esc>pk"
    else
	exe "normal `<a</\<Esc>pl"
    endif
endfunction

" This function searches backward for the first unmatched <...>
" WARNING!!  It ignores <p>, <br>, <li>, <im..>, and their capitalized
" versions.  It will miscount if these are completed with </p>, etc.
" Make sure you have a <HTML> or <html> or <Html>, etc, at the start of
" your file, or this function won't work.

function! s:GoBackwardToTag()
    let s:found = 2
    while s:found > 1
	exe "normal ?<\<CR>"
	let s:string = strpart(getline(line(".")),col("."),2)
	if s:string[0] == '/'
		let s:found = s:found + 1
	elseif s:string !~ "!-\\\|\[Pp]>\\\|\[Bb]\[Rr]\\\|\[Ll]\[Ii]\\\|\[Hh]\[Rr]\\\|\[Ii]\[Mm]"
		let s:found = s:found - 1
	endif
    endwhile
endfunction

noremap <buffer> <C-Del> :call <SID>DeleteTagForward()<CR>
function! s:DeleteTagForward()
    let s:string = strpart(getline(line(".")),col(".")-1,3)
    if s:string[0] == "<" && s:string[1] != "/"
	normal df>
	let s:look = strpart(s:string,1,2)
	if s:look[1] == " "
	    let s:look = s:look[0] . ">"
	endif
	exe "normal /<\\/" . s:look . "\<CR>"
	normal df>
    endif
endfunction

inoremap <buffer> < <><Left>
inoremap <buffer> <M-,> <

" Auctex style mode
set notimeout
inoremap <buffer> ;; ;
inoremap <buffer> ;1 <h1></h1><Esc>4hi
inoremap <buffer> ;2 <h2></h2><Esc>4hi
inoremap <buffer> ;3 <h3></h3><Esc>4hi
inoremap <buffer> ;4 <h4></h4><Esc>4hi
inoremap <buffer> ;5 <h5></h5><Esc>4hi
inoremap <buffer> ;ad <address></address><Esc>F<i
inoremap <buffer> ;ah <a href=""></a><Esc>F"i
inoremap <buffer> ;am <a href="mailto:"></a><Esc>F"i
inoremap <buffer> ;an <a name=""></a><Esc>F"i
inoremap <buffer> ;b <br>
inoremap <buffer> ;c <center></center><Esc>F<i
inoremap <buffer> ;dd <dd>
inoremap <buffer> ;dl <dl><Esc>o</dl><Esc>O
inoremap <buffer> ;dt <dt>
inoremap <buffer> ;e <em></em><Esc>F<i
inoremap <buffer> ;f <font ></font><Esc>F>i
inoremap <buffer> ;h <hr>
inoremap <buffer> ;i <IMG src="" alt=""><Esc>8hi
inoremap <buffer> ;l <li>
inoremap <buffer> ;o <ol><Esc>o</ol><Esc>O
inoremap <buffer> ;p <p>
inoremap <buffer> ;s <strong></strong><Esc>F<i
inoremap <buffer> ;ta <table><Esc>o</table><Esc>O
inoremap <buffer> ;td <td></td><Esc>F<i
inoremap <buffer> ;th <th></th><Esc>F<i
inoremap <buffer> ;tr <tr><Esc>o</tr><Esc>O
inoremap <buffer> ;u <ul><Esc>o<li><Esc>o</ul><Esc>O
inoremap <buffer> ;C <!--  --><Esc>F<Space>i
inoremap <buffer> ;R <!==  ==><Esc>F<Space>i
inoremap <buffer> ;H <a href=""></a><Esc>F<i
inoremap <buffer> ;I <IMG src="" alt=""><Esc>F<i
inoremap <buffer> ;M <a href="mailto:"></a><Esc>F<i

" Auctex style for the visual mode.  Surrounds the region by the
" appropriate pair of tags.
vnoremap <buffer> <F3> <C-C>`>a</a<C-V>><Esc>`<i<a href=""><Esc>v<C-C>`<hi
vnoremap <buffer> ;ah <C-C>`>a</a<C-V>><Esc>`<i<a href=""><Esc>v<C-C>`<hi
vnoremap <buffer> ;1 <C-C>:call <SID>InsertTag("h1")<CR>
vnoremap <buffer> ;2 <C-C>:call <SID>InsertTag("h2")<CR>
vnoremap <buffer> ;3 <C-C>:call <SID>InsertTag("h3")<CR>
vnoremap <buffer> ;4 <C-C>:call <SID>InsertTag("h4")<CR>
vnoremap <buffer> ;5 <C-C>:call <SID>InsertTag("h5")<CR>
vnoremap <buffer> ;ad <C-C>:call <SID>InsertTag("address")<CR>
vnoremap <buffer> ;c <C-C>:call <SID>InsertTag("center")<CR>
vnoremap <buffer> ;dd <C-C>:call <SID>InsertTag("dd")<CR>
vnoremap <buffer> ;dl <C-C>:call <SID>InsertTag("dl")<CR>
vnoremap <buffer> ;dt <C-C>:call <SID>InsertTag("dt")<CR>
vnoremap <buffer> ;e <C-C>:call <SID>InsertTag("em")<CR>
vnoremap <buffer> ;f <C-C>:call <SID>InsertTag("font")<CR>
vnoremap <buffer> ;o <C-C>:call <SID>InsertTag("ol")<CR>
vnoremap <buffer> ;s <C-C>:call <SID>InsertTag("strong")<CR>
vnoremap <buffer> ;ta <C-C>:call <SID>InsertTag("table")<CR>
vnoremap <buffer> ;td <C-C>:call <SID>InsertTag("td")<CR>
vnoremap <buffer> ;th <C-C>:call <SID>InsertTag("th")<CR>
vnoremap <buffer> ;tr <C-C>:call <SID>InsertTag("tr")<CR>
vnoremap <buffer> ;u <C-C>:call <SID>InsertTag("ul")<CR>
vnoremap <buffer> ;C <C-C>`>a --<C-V>><Esc>`<i<!-- <Esc>
vnoremap <buffer> ;R <C-C>`>a ==<C-V>><Esc>`<i<!== <Esc>

nnoremenu 40.401 Html.template\ \ \ \ \ \ \ \ F1 :if strpart(getline(1),0,6) !~ "^<\[Hh]\[Tt]\[Mm]\[Ll]>"<CR>0read ~/.Vim/html-template.vim<CR>normal /<\/title\\|<\/TITLE<CR><CR>:endif<CR>i
inoremenu 40.402 Html.one-line\ tag\ \ \ \ F1 <Esc>:call <SID>OneLineCompletion()<CR>i
inoremenu 40.403 Html.two-line\ tag\ \ \ \ F2 <Esc>:call <SID>ThreeLineCompletion()<CR>a
inoremenu 40.404 Html.href\ \ \ \ \ \ \ \ \ \ \ \ F3 <a href=""></a><Left><Left><Left><Left><Left><Left>
inoremenu 40.405 Html.email\ \ \ \ \ \ \ \ \ \ \ F4 <a href="mailto:"></a><Left><Left><Left><Left><Left><Left>
vnoremenu 40.406 Html.embrace\ \ \ \ \ \ \ \ \ F1 <C-C>a <Esc>`>i</><Esc>`<i<><Esc>$x`<a
inoremenu 40.408 Html.put\ image\ \ \ \ \ \ \ F5 <IMG SRC=""><Left><Left>
