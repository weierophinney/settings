" -*- vim -*-
"
" This is the (P)HP(D)ocumentor (S)kript for VIM (PDocS for short)
"
" Copyright (c) 2002, 2003 by Karl Heinz Marbaise <khmarbaise@gmx.de>
" 
" This is a script for simplifying documentation of PHP code
" using PHPDocumentor (www.phpdoc.org) Doc-Blocks.
" Most of the time you will copy/paste the commets from one place to
" another but with this script you will be able to generate PHPDoc
" while you are typing source-code.
"
" Release:		0.26
"
" Tested:		VIM 6.1
" 
" Version:		$Id: phpdoc.vim,v 1.8 2003/01/05 14:59:41 kama Exp $
" 
" Author:		Karl Heinz Marbaise <khmarbaise@gmx.de>
"
" Installation: Just copy it to your plugin directory
" 				Change Authors-Name and e-mail adress and may be the text
" 				which will be inserted.
" 				
" Description:	It supports you in writing PHPDoc-Style Block-Comments
" 				while writing PHP-Code. Using this script it is no
" 				more needed to copy and paste the PHPDoc-Style Block-Commets
" 				over and over you just type e.g. "class Test {" and you will 
" 				get an filled out PHPDoc-Style Block comments above the class.
"
" Feedback:		If you have improvements, corrections, critism etc.
"				I'm apreciated to here from you about your comments etc.
"				just drop an e-mail to me.
"
" Todo:		-	I would like to have the text which will be inserted for
" 				functions/classes/vars etc. in an external file which can be 
" 				changed during runtime instead of hacking this script!
"			-	Improve doc.
"			-	...?
"
" Plans:	-	Create a Unit-Testing script based on just the Class-Name
"				(skeleton)
"
" 
" This Skript is based on the following styleguide conventions.
"
"	Variables: (prefix in lowercase)
"		$aTest	Array
"		$bTest	Boolean
"		$dTest	double
"		$sTest	string
"		$iTest	integer
"		$oTest	object
"
"	class:
"		$_aTest means private array variable (the usual way! I mean private
"		not the array ;-))
"		following the "_" the above prefix.
"		$aTest means public variable, but this should never be used in OOP!
"	
"	methods:
"		function aGetFile () result array...
"		function bIsEqual() result boolean.. can be written function isEqual 
"		function sGetFile() result string...
"		etc. like the Variables prefix above.
"		but no rule without exceptions...
"		 if starting with "set..." then no prefix is used no return value...
"		 	The part of the set-Operations for classes...
"		 if starting with "is..." then no prefix is used but return boolean
"		 (isEqual, isSet etc.)
"
"
"		function "_"... private function or method (operation)
"
"	if a function/method is started with an "_" the @access tag is set
"	to private otherwise public.
" 
"
" 
" ==================== file foo.vimrc ====================
" User Configuration file for foo.vim .
let g:foo_DefineAutoCommands = 1  " default 0, do not define autocommands.
" ==================== end: foo.vimrc ====================

" source the user configuration file(s):
runtime! plugin/<sfile>:t:r.vimrc
"
" *** End of User Configuration ***
" 
" 
if g:foo_DefineAutoCommands
	augroup Foo
	autocmd BufEnter *.php inoremap ) )<Esc>:call ClassHeader()<CR>a<Esc>:call FuncHeader()<CR>a
	autocmd BufEnter *.php inoremap { {<Esc>:call ClassHeader()<CR>a<Esc>:call FuncHeader()<CR>a
	autocmd BufEnter *.php inoremap ; ;<Esc>:call ClassVar()<CR>a
	autocmd BufLeave *.php iunmap {
	autocmd BufLeave *.php iunmap ;
	" Keep your braces balanced!}}}
endif " g:foo_DefineAutoCommands
" 
" Get the Type of an variable/function/method
" based on the prefixes defines in styleguide
" If no prefix matches we use mixed as type.
" 
function GetPHPDocType(prefix)
	let l:type = 'mixed'
	if a:prefix == 'a'
		let l:type = 'array'
	endif
	if a:prefix == 'b'
		let l:type = 'boolean'
	endif
	if a:prefix == 'd'
		let l:type = 'double'
	endif
	if a:prefix == 'i'
		let l:type = 'integer'
	endif
	if a:prefix == 's'
		let l:type = 'string'
	endif
	if a:prefix == 'o'
		let l:type = 'object'
	endif
	return l:type
endfun
"
" Check if a function starts with "set" or "is", 
" cause it is most often used for "get"/"set" operation
" of classes and "is" is used for checking if set...
" like "isEnabled()" etc. for boolean functions.
"
function GetReturnOfPHPFunction(line,index)
	" Does the function name start with "set..."?
	if match(a:line, '^set', a:index) > -1
		let l:returntype = ''
	" Does the function name start with "is..."?
	elseif match(a:line, '^is', a:index) > -1
		" Such kind of functions are like isEnabled () so the return
		" type is 'boolean'.
		let l:returntype = 'boolean'
	else	
		let l:prefix = matchstr(a:line, '[A-Za-z]', a:index) 
		" Get return type of function base on Prefix...
		let l:returntype = GetPHPDocType(l:prefix) 
	endif
	return l:returntype
endfun
"
" This function is called every time you type "{"
" this is usualy done if you are declaring a class or a function
"
fun! ClassHeader()
	if getline(".") !~ "^\\s*class"
		return
	endif

	let l:line = getline(".")
    
    " Strip trailing brace (will start next line with it
    let l:lineindex = line(".")
    if (match(l:line, "{$"))
        let l:line = substitute(l:line, "\s*{$", "", "")
        call setline(l:lineindex, l:line)
    endif

    mark x

	"--------------------------------------------------
	" seemed not to work in this context..?
	" " save our position 
	" let SaveL = line(".")
	" let SaveC = virtcol(".")
	" " :help restore-position
	" execute ":normal! H"
	" let SaveT = line('.')
	" execute ":normal! ".SaveL."G"
	"-------------------------------------------------- 

	" Get the prefix of the line to indent the
	" auto inserted text the same as the rest...
    let l:curLine = getline('.')
    if l:curLine =~ '^\s\+'
        let l:indent = matchstr(l:curLine, '^\s*')
    else
        let l:indent = ''
    endif

    let @y = l:indent . "{\n"
    let @y = @y . l:indent . "}"
    put y

    'x

	let @z = l:indent . "/**\n"
	let @z=@z . l:indent . " * This is the short Description for the Class\n"
	let @z=@z . l:indent . " *\n"
	let @z=@z . l:indent . " * This is the long description for the Class\n"
	let @z=@z . l:indent . " *\n"
	let @z=@z . l:indent . " * @package Package\n"
	let @z=@z . l:indent . " * @author Matthew Weier O'Phinney <matthew@zend.com>\n"
	let @z=@z . l:indent . " * @copyright (c) 2006 - Present, Zend Technologies, Inc.\n"
	" prevent RCS/CVS to expand the Id Keyword.
	let @z=@z . l:indent . " * @version $" . "Id:$\n"
	"let @z=@z . l:indent . " * @subpackage SubPackage\n"
	"let @z=@z . l:indent . " * @see ??\n"
	let @z=@z . l:indent . " */\n"
	put! z
	"--------------------------------------------------
	" " go back to where we were.
	" execute ":normal! ".SaveT."Gzt"
	" execute ":normal! ".SaveL."G"
	" execute ":normal! ".SaveC."|"
	"-------------------------------------------------- 
endfun
"
" Insert a Header every time you begin a new function...
"
fun! FuncHeader()
	if getline(".") !~ '^\s*\(\(public\|private\|static\|protected\) \)*function\s\+'
		return
	endif

    " Get line
	let l:line = getline(".")

    " Strip trailing brace (will start next line with it
    let l:lineindex = line(".")
    if (match(l:line, "{$"))
        let l:line = substitute(l:line, "\s*{$", "", "")
        call setline(l:lineindex, l:line)
    endif


    " Set mark at this line 
    mark x

	let l:access = ''
	" Get the prefix of the l:line to l:indent the
	" auto inserted text the same as the rest...
    if l:line =~ '^\s\+'
        let l:indent = matchstr(l:line, '^\s*')
    else
        let l:indent = ''
    endif
	let @z = ''
	" default empty type...
	let l:returntype = ''

    if l:line =~ '^\s*\(\(public\|private\|protected\|static\) \)*function\s\+_'
        let l:index = matchend(l:line, '^\s*\(\(public\|private\|protected\|static\) \)*function\s\+_'
    elseif l:line =~ '^\s*\(\(public\|private\|protected\|static\) \)*function\s\+[A-Za-z]\+'
        let l:index = matchend(l:line, '^\s*\(\(public\|private\|protected\|static\) \)*function\s\+')
    endif
    let l:returntype = GetReturnOfPHPFunction(l:line,l:index)

    if l:line =~ 'private '
        let l:access = 'private'
    elseif l:line =~ 'protected '
        let l:access = 'protected'
    else
        let l:access = 'public'
    endif

    if l:line =~ 'static '
        let l:static = 1
    else
        let l:static = 0
    endif

	if l:line =~ '(.*)'
		let parameter = matchstr(l:line, '(.*)')
		" let @z = @z . 'Parameter ="' . parameter . '"'
	endif

    " Add braces after line
    let @y = ''
    let @y = @y . l:indent . "{\n"
    let @y = @y . l:indent . "}\n"
    put y

    " Return to line
    'x

    " Build docblock
	let @z=@z . l:indent . "/**\n"
	let @z=@z . l:indent . " * This is the short Description for the Function\n"
	let @z=@z . l:indent . " *\n"
	let @z=@z . l:indent . " * This is the long description for the function\n"
	let @z=@z . l:indent . " *\n"

    " Notify if it's a static method
    if l:static == 1
        let @z = @z . l:indent . " * @static\n"
    endif

    "
	" Insert return type of function....
	if l:returntype != ''
		let @z = @z . l:indent . " * @return " . l:returntype . " Description\n"
	endif
	let @z=@z . l:indent . " * @access " . l:access . "\n"
	" let @z=@z . l:indent . " * @see ??\n"
	let @z=@z . l:indent . " */\n"
	put! z

endfun
"
"
"
fun! ClassVar()
	if getline(".") !~ '^\s*\(var\|protected\|private\|static\|public\)\s\+\$'
		return
	endif
	let l:line = getline(".")
	let l:prefix = ''
	" Get the l:prefix of the l:line to l:indent the
	" auto inserted text the same as the rest...
    if l:line =~ '^\s\+'
        let l:indent = matchstr(l:line, '^\s*')
    else
        let l:indent = ''
    endif
	" check if the first character of the name "_"
	" then private else public
	" and get the l:prefix of the variable name...to get the type..
    if l:line =~ '^\s*\(var\|public\|static\)'
        let l:access = 'public'
    else
        let l:access = 'private'
    endif
	if l:line =~ '^\s*\(var\|protected\|private\|static\|public\)\s\+\$[A-Za-z]\+'
		let l:index = matchend(l:line, '^\s*\(var\|protected\|private\|static\|public\)\s\+\$')
		let l:prefix = matchstr(l:line, '[A-Za-z]', l:index) 
	endif

	if l:line =~ '^\s*\(var\|protected\|private\|static\|public\)\s\+\$_'
		let l:index = matchend(l:line, '^\s*\(var\|protected\|private\|static\|public\)\s\+\$_')
		let l:prefix = matchstr(l:line, '[A-Za-z]', l:index)
	endif

    let l:varstart = matchend(l:line, '^\s*\(var\|protected\|private\|static\|public\)\s\+\$')
    let l:varend = match(l:line, ';')
    if (l:varend != -1)
        if (l:varstart != -1)
            let l:varlen = l:varend - l:varstart
            let l:varname = strpart(l:line, l:varstart, l:varlen)
            let l:varname = '$' . l:varname
        else
            let l:varname = '$VARNAME'
        endif
    else
        let l:varname = '$VARNAME'
    endif

	"let l:type = GetPHPDocType(prefix)
    let l:type = 'string'

	let @z= l:indent . "/**\n"
    let @z=@z . l:indent . " * Description\n"
	let @z=@z . l:indent . " * @var " . l:type . " \n"
	" let @z=@z . l:indent . " * @var " . l:type . "\n"
	let @z=@z . l:indent . " * @access " . l:access . "\n"
	let @z=@z . l:indent . " */\n"
	put! z
endfun
