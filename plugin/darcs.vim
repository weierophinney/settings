" ==============================================================================
"        File: darcs.vim
"      Author: Srinath Avadhanula (srinathava [AT] gmail [DOT] com)
"        Help: darcs.vim is a plugin which implements some simple mappings
"              to make it easier to use darcs, David Roundy's distributed
"              revisioning system.
"   Copyright: Srinath Avadhanula
"     License: Vim Charityware license. (:help uganda)
"
" As of right now, this script provides the following mappings:
"
" 	<Plug>DarcsVertDiffsplit
" 		This mapping vertically diffsplit's the current window with the
" 		last recorded version.
"
" 		Default map: <leader>dkv
"
" 	<Plug>DarcsIneractiveDiff
" 		This mapping displays the changes for the current file. The user
" 		can then choose two revisions from the list using the 'f' (from)
" 		and 't' (to) keys. After choosing two revisions, the user can press
" 		'g' at which point, the delta between those two revisions is
" 		displayed in two veritcally diffsplit'ted windows.
"
" 		Default map: <leader>dki
"
" 	<Plug>DarcsStartCommitSession
" 		This mapping starts an interactive commit console using which the
" 		user can choose which hunks to include in the record and then also
" 		write out a patch name and commit message.
"
" 		Default map: <leader>dkc
" ==============================================================================

" ==============================================================================
" Main functions
" ==============================================================================
" Functions related to diffsplitting current file with last recorded {{{

nmap <Plug>DarcsVertDiffsplit :call Darcs_DiffSplit()<CR>
if !hasmapto('<Plug>DarcsVertDiffsplit')
	nmap <unique> <leader>dkv <Plug>DarcsVertDiffsplit
endif

" Darcs_DiffSplit: diffsplits the current file with last recorded version {{{
function! Darcs_DiffSplit()
	let origDir = getcwd()
	call Darcs_CD(expand('%:p:h'))

	" first find out the location of the repository by searching upwards
	" from the current directory for a _darcs* directory.
	if Darcs_SetDarcsDirectory() < 0
        return -1
    endif

	" Find out if the current file has any changes.
	if Darcs_System('darcs whatsnew '.expand('%')) =~ '\(^\|\n\)No changes'
		echomsg "darcs says there are no changes"
		return 0
	endif

    " Find out the relative path name from the parent dir of the _darcs
    " directory to the location of the presently edited file
    let relPath = strpart(expand('%:p'), strlen(b:darcs_repoDirectory))

    " The last recorded file lies in
    "   $DIR/_darcs/current/relative/path/to/file
    " where
    "   $DIR/relative/path/to/file
    " is the actual path of the file
    let lastRecFile = b:darcs_repoDirectory . '/'
        \ . '_darcs/current' . relPath

	call Darcs_Debug(':Darcs_DiffSplit: lastRecFile = '.lastRecFile)

	call Darcs_NoteViewState()

	execute 'vert diffsplit '.lastRecFile
	" The file in _darcs/current should not be edited by the user.
	setlocal readonly

	nmap <buffer> q <Plug>DarcsRestoreViewAndQuit

	call Darcs_CD(origDir)
endfunction

" }}}
" Darcs_SetDarcsDirectory: finds which _darcs directory contains this file {{{
" Description: This function searches upwards from the current directory for a
"              _darcs directory.
function! Darcs_SetDarcsDirectory()
	let filename = expand('%:p')
	let origDir = getcwd()
	let foundFile = 0

	call Darcs_CD(expand('%:p:h'))
	let lastDir = getcwd()
    while glob('_darcs*') == ''
        lcd ..
        " If we cannot go up any further, then break
        if lastDir == getcwd()
            break
        endif
		let lastDir = getcwd()
    endwhile

    " If a _darcs directory was never found, then quit...
    if glob('_darcs*') == ''
        echohl Error
        echo "_darcs directory not found in or above current directory"
        echohl None
        return -1
    endif

	let b:darcs_repoDirectory = getcwd()
	
	call Darcs_CD(origDir)

    return 0
endfunction

" }}}

" }}}
" Functions related to interactive diff splitting {{{

nmap <Plug>DarcsIneractiveDiff :call Darcs_StartInteractiveDiffSplit()<CR>
if !hasmapto('<Plug>DarcsIneractiveDiff')
	nmap <unique> <leader>dki <Plug>DarcsIneractiveDiff
endif

" Darcs_StartInteractiveDiffSplit: initializes the interactive diffsplit session {{{
function! Darcs_StartInteractiveDiffSplit()
	let origdir = getcwd()
	let filedir = expand('%:p:h')
	let filename = expand('%:p:t')
	let filetype = &l:ft

	call Darcs_CD(filedir)
	call Darcs_OpenScratchBuffer()

	let changelog = Darcs_FormatChangelog(filename)
	if changelog == ''
		echomsg "darcs does not know about this file"
		return
	endif
	0put=Darcs_FormatChangelog(filename)

	call Darcs_CD(origdir)

	set ft=changelog
	" reading in stuff creates an extra line ending
	$ d _

	let header = 
		\ '====[ Darcs diff console: Mappings ]==========================' . "\n" .
		\ "\n" .
		\ 'j/k	: next/previous patch' . "\n" .
		\ 'f  	: set "from" patch' . "\n" .
		\ 't  	: set "to" patch' . "\n" .
		\ 'g	: proceed with diff (Go)' . "\n" .
		\ 'q	: quit without doing anything further'. "\n" .
		\ '=============================================================='
	0put=header
	normal! gg
	
	let b:darcs_FROM_hash = ''
	let b:darcs_TO_hash = ''
	let b:darcs_orig_ft = filetype
	let b:darcs_orig_file = filename
	let b:darcs_orig_dir = filedir

	nmap <buffer> j <Plug>DarcsGotoNextChange
	nmap <buffer> k <Plug>DarcsGotoPreviousChange
	nmap <buffer> f <Plug>DarcsSetFromHash
	nmap <buffer> t <Plug>DarcsSetToHash
	nmap <buffer> g <Plug>DarcsProceedWithDiffSplit
	nmap <buffer> q :q<CR>:<BS>

	call search('^\s*\*')
endfunction

" }}}
" Darcs_FormatChangelog: creates a Changelog with hash for a file {{{
function! Darcs_FormatChangelog(filename)

	" remove the first <created_as ../> entry
	let xmloutput = Darcs_System('darcs changes --xml-output '.a:filename)
	" TODO: We need to see if there were any errors generated by darcs or
	" if the xmloutput is empty.
	
	let idx = match(xmloutput, '<\/created_as>')
	let xmloutput = strpart(xmloutput, idx + strlen('</created_as>'))

	let changelog = ""

	" For each patch in the xml output
	let idx = match(xmloutput, '</patch>')
	while idx != -1
		" extract the actual patch.
		let patch = strpart(xmloutput, 0, idx)

		" From the patch, extract the various fields.
		let name = matchstr(patch, '<name>\zs.*\ze<\/name>')
		let comment = matchstr(patch, '<comment>\zs.*\ze</comment>')

		let pattern = ".*<patch author='\\(.\\{-}\\)' date='\\(.\\{-}\\)' local_date='\\(.\\{-}\\)' inverted='\\(True\\|False\\)' hash='\\(.\\{-}\\)'>.*"

		let author = substitute(patch, pattern, '\1', '')
		let date = substitute(patch, pattern, '\2', '')
		let local_date = substitute(patch, pattern, '\3', '')
		let inverted = substitute(patch, pattern, '\4', '')
		let hash = substitute(patch, pattern, '\5', '')

		" Create the formatted changelog entry for this patch.
		" Unfortunately, we do not have the +M -5 +10 kind of line in this
		" output. Price to pay...
		let formatted = "[hash ".hash."]\n".local_date.' '.author."\n  * ".name."\n".
					\ substitute(comment, "\n", "\n  ", 'g')."\n\n"

		let changelog = changelog.formatted

		" Once the patch has been processed, snip if from the xml output.
		let xmloutput = strpart(xmloutput, idx + strlen('</patch>'))
		let idx = match(xmloutput, '</patch>')
	endwhile
	
	if changelog != ''
		let changelog = "Changes in ".a:filename.":\n\n".changelog

		let s:sub_{'&apos;'} = "'"
		let s:sub_{'&quot;'} = '"'
		let s:sub_{'&amp;'} = '&'
		let s:sub_{'&lt;'} = '<'
		let s:sub_{'&gt;'} = '>'

		function! Eval(expr)
			if exists("s:sub_{'".a:expr."'}")
				return s:sub_{a:expr}
			else
				return a:expr
			endif
		endfunction

		let changelog = substitute(changelog, '&\w\{2,4};', '\=Eval(submatch(0))', 'g')

		return changelog

	else
		return ""
	endif

endfunction

" }}}
" Darcs_SetHash: remembers the user's from/to hashs for the diff {{{

nnoremap <Plug>DarcsSetToHash :call Darcs_SetHash('TO')<CR>
nnoremap <Plug>DarcsSetFromHash :call Darcs_SetHash('FROM')<CR>

function! Darcs_SetHash(fromto)
	normal! $
	call search('^\s*\*', 'bw')

	" First remove any previous mark set.
	execute '% s/'.a:fromto.'$//e'

	" remember the present line's hash
	let b:darcs_{a:fromto}_hash = matchstr(getline(line('.')-2), '\[hash \zs.\{-}\ze\]')

	call setline(line('.')-1, getline(line('.')-1).'  '.a:fromto)
endfunction

" }}}
" Darcs_GotoChange: goes to the next previous change {{{

nnoremap <Plug>DarcsGotoPreviousChange :call Darcs_GotoChange('b')<CR>
nnoremap <Plug>DarcsGotoNextChange :call Darcs_GotoChange('')<CR>

function! Darcs_GotoChange(dirn)
	call search('^\s*\*', a:dirn.'w')
endfunction

" }}}
" Darcs_ProceedWithDiff: proceeds with the actual diff between requested versions {{{
" Description: 

nnoremap <Plug>DarcsProceedWithDiffSplit :call Darcs_ProceedWithDiff()<CR>

function! Darcs_ProceedWithDiff()
	call Darcs_Debug('+Darcs_ProceedWithDiff')

	if b:darcs_FROM_hash == '' && b:darcs_TO_hash == ''
		echohl Error
		echo "You need to set at least one of the FROM or TO hashes"
		echohl None
		return -1
	endif

	let origDir = getcwd()

	call Darcs_CD(b:darcs_orig_dir)

	let ft = b:darcs_orig_ft
	let filename = b:darcs_orig_file
	let fromhash = b:darcs_FROM_hash
	let tohash = b:darcs_TO_hash

	" quit the window which shows the Changelog
	q

	" First copy the present file into a temporary location
	let tmpfile = tempname().'__present'

	call Darcs_System('cp '.filename.' '.tmpfile)

	if fromhash != ''
		let tmpfilefrom = tempname().'__from'
		call Darcs_RevertToState(filename, fromhash, tmpfilefrom)
		let file1 = tmpfilefrom
	else
		let file1 = filename
	endif

	if tohash != ''
		let tmpfileto = tempname().'__to'
		call Darcs_RevertToState(filename, tohash, tmpfileto)
		let file2 = tmpfileto
	else
		let file2 = filename
	endif

	call Darcs_Debug(':Darcs_ProceedWithDiff: file1 = '.file1.', file2 = '.file2)

	execute 'split '.file1
	execute "nnoremap <buffer> q :q\<CR>:e ".file2."\<CR>:q\<CR>"
	let &l:ft = ft
	execute 'vert diffsplit '.file2
	let &l:ft = ft
	execute "nnoremap <buffer> q :q\<CR>:e ".file1."\<CR>:q\<CR>"
	
	call Darcs_CD(origDir)

	call Darcs_Debug('-Darcs_ProceedWithDiff')
endfunction 

" }}}
" Darcs_RevertToState: reverts a file to a previous state {{{
function! Darcs_RevertToState(filename, patchhash, tmpfile)
	call Darcs_Debug('+Darcs_RevertToState: pwd = '.getcwd())

	let syscmd = "darcs diff --from-match \"hash ".a:patchhash."\" ".a:filename.
		\ " | patch -R ".a:filename." -o ".a:tmpfile
	call Darcs_Debug(':Darcs_RevertToState: syscmd = '.syscmd)
	call Darcs_System(syscmd)

	let syscmd = "darcs diff --match \"hash ".a:patchhash."\" ".a:filename.
		\ " | patch ".a:tmpfile
	call Darcs_Debug(':Darcs_RevertToState: syscmd = '.syscmd)
	call Darcs_System(syscmd)

	call Darcs_Debug('-Darcs_RevertToState')
endfunction 

" }}}

" }}}
" Functions related to interactive comitting {{{

nmap <Plug>DarcsStartCommitSession :call Darcs_StartCommitSession()<CR>
if !hasmapto('<Plug>DarcsStartCommitSession')
	nmap <unique> <leader>dkc <Plug>DarcsStartCommitSession
endif

" Darcs_StartCommitSession: start an interactive commit "console" {{{
function! Darcs_StartCommitSession()

	let origdir = getcwd()
	let filename = expand('%:p:t')
	let filedir = expand('%:p:h')
	
	call Darcs_CD(filedir)
	let wn = Darcs_System('darcs whatsnew --no-summary --dont-look-for-adds')
	call Darcs_CD(origdir)

	if wn =~ '^No changes!'
		echo "No changes seen by darcs"
		return
	endif

	" read in the contents of the `darcs whatsnew` command
	call Darcs_SetSilent('silent')

	" opens a scratch buffer for the commit console
	" Unfortunately, it looks like the temporary file has to exist in the
	" present directory because at least on Windows, darcs doesn't want to
	" handle absolute path names containing ':' correctly.
	exec "top split ".Darcs_GetTempName(expand('%:p:h'))
	0put=wn

	" Delete the end and beginning markers
	g/^[{}]$/d _
	" Put an additional four spaces in front of all lines and a little
	" checkbox in front of the hunk specifier lines
	% s/^/    /
	% s/^    hunk/[ ] hunk/

	let header = 
		\ '====[ Darcs commit console: Mappings ]========================' . "\n" .
		\ "\n" .
		\ 'J/K	: next/previous hunk' . "\n" .
		\ 'Y/N	: accept/reject this hunk' . "\n" .
		\ 'F/S	: accept/reject all hunks from this file' . "\n" .
		\ 'A/U	: accept/reject all (remaining) hunks' . "\n" .
		\ 'q	: quit this session without committing' . "\n" .
		\ 'L	: goto log area to record description'. "\n" .
		\ 'R	: done! finish record' . "\n" .
		\ '=============================================================='
	0put=header

	let footer = 
		\ '====[ Darcs commit console: Commit log description ]==========' . "\n" .
		\ "\n" .
		\ '***DARCS***'. "\n".
		\ 'Write the long patch description in this area.'. "\n".
		\ 'The first line in this area will be the patch name.'. "\n".
		\ 'Everything in this area from the above ***DARCS*** line on '."\n".
		\ 'will be ignored.'. "\n" .
		\ '=============================================================='
	$put=footer

	set nomodified
	call Darcs_SetSilent('notsilent')

	" Set the fold expression so that things get folded up nicely.
	set fdm=expr
	set foldexpr=Darcs_WhatsNewFoldExpr(v:lnum)

	" Finally goto the first hunk
	normal! G
	call search('^\[ ', 'w')

	nnoremap <buffer> J :call Darcs_GotoHunk('')<CR>:<BS>
	nnoremap <buffer> K :call Darcs_GotoHunk('b')<CR>:<BS>

	nnoremap <buffer> Y :call Darcs_SetHunkVal('y')<CR>:<BS>
	nnoremap <buffer> N :call Darcs_SetHunkVal('n')<CR>:<BS>

	nnoremap <buffer> A :call Darcs_SetRemainingHunkVals('y')<CR>:<BS>
	nnoremap <buffer> U :call Darcs_SetRemainingHunkVals('n')<CR>:<BS>

	nnoremap <buffer> F :call Darcs_SetFileHunkVals('y')<CR>:<BS>
	nnoremap <buffer> S :call Darcs_SetFileHunkVals('n')<CR>:<BS>

	nnoremap <buffer> L :call Darcs_GotoLogArea()<CR>
	nnoremap <buffer> R :call Darcs_FinishCommitSession()<CR>

	nnoremap <buffer> q :call Darcs_DeleteTempFile(expand('%:p'))<CR>

	let b:darcs_orig_file = filename
	let b:darcs_orig_dir = filedir
endfunction

" }}}
" Darcs_WhatsNewFoldExpr: foldexpr function for a commit console {{{
function! Darcs_WhatsNewFoldExpr(lnum)
	if matchstr(getline(a:lnum), '^\[[yn ]\]') != ''
		return '>1'
	elseif matchstr(getline(a:lnum+1), '^====\[ .* log description') != ''
		return '<1'
	else
		return '='
	endif
endfunction

" }}}
" Darcs_GotoHunk: goto next/previous hunk in a commit console {{{
function! Darcs_GotoHunk(dirn)
	call search('^\[[yn ]\]', a:dirn.'w')
endfunction

" }}}
" Darcs_SetHunkVal: accept/reject a hunk for committing {{{
function! Darcs_SetHunkVal(yesno)
	if matchstr(getline('.'), '\[[yn ]\]') == ''
		return
	end
	execute "s/^\\[.\\]/[".a:yesno."]"
	call Darcs_GotoHunk('')
endfunction

" }}}
" Darcs_SetRemainingHunkVals: accept/reject all remaining hunks {{{
function! Darcs_SetRemainingHunkVals(yesno)
	execute "% s/^\\[ \\]/[".a:yesno."]/e"
endfunction 

" }}}
" Darcs_SetFileHunkVals: accept/reject all hunks from this file {{{
function! Darcs_SetFileHunkVals(yesno)
	" If we are not on a hunk line for some reason, then do not do
	" anything.
	if matchstr(getline('.'), '\[[yn ]\]') == ''
		return
	end

	" extract the file name from the current line
	let filename = matchstr(getline('.'), 
		\ '^\[[yn ]\] hunk \zs\f\+\ze')
	if filename == ''
		return
	endif

	" mark all hunks belonging to the file with yes/no
	execute '% s/^\[\zs[yn ]\ze\] hunk '.escape(filename, "\\/").'/'.a:yesno.'/e'

	call Darcs_GotoHunk('')
endfunction 

" }}}
" Darcs_GotoLogArea: records the log description of the commit {{{
function! Darcs_GotoLogArea()
	if search('^\[ \]')
		echohl WarningMsg
		echo "There are still some hunks which are neither accepted or rejected"
		echo "Please set the status of all hunks before proceeding to log"
		echohl None

		return
	endif

	call search('\M^***DARCS***')
	normal! k
	startinsert
endfunction 

" }}}
" Darcs_FinishCommitSession: finishes the interactive commit session {{{
function! Darcs_FinishCommitSession()

	" First make sure that all hunks have been set as accpeted or rejected.
	if search('^\[ \]')

		echohl WarningMsg
		echo "There are still some hunks which are neither accepted or rejected"
		echo "Please set the status of all hunks before proceeding to log"
		echohl None

		return
	endif

	" Then make a list of the form "ynyy..." from the choices made by the
	" user.
	let yesnolist = ''
	g/^\[[yn]\]/let yesnolist = yesnolist.matchstr(getline('.'), '^\[\zs.\ze\]')

	" make sure that a valid log message has been written.
	call search('====\[ Darcs commit console: Commit log description \]', 'w')
	normal! j
	let _k = @k
	execute "normal! V/\\M***DARCS***/s\<CR>k\"ky"

	let logMessage = @k
	let @k = _k

	call Darcs_Debug(':Darcs_FinishCommitSession: logMessage = '.logMessage)
	call Darcs_Debug(':Darcs_FinishCommitSession: yesnolist = ['.yesnolist.']')

	if logMessage !~ '[[:graph:]]'

		echohl WarningMsg
		echo "The log message is either ill formed or empty"
		echo "Please repair the mistake and retry"
		echohl None

		return
	endif

	" Remove everything from the file except the log file.
	% d _
	0put=logMessage
	$ d _
	w

	let origDir = getcwd()
	call Darcs_CD(b:darcs_orig_dir)

	let darcsOut = Darcs_System('echo '.yesnolist.' | darcs record --logfile='.expand('%:p:t'))

	call Darcs_CD(origDir)

	% d _
	0put=darcsOut

	let footer = 
		\ "=================================================================\n".
		\ "Press q to delete this temporary file and quit the commit session\n".
		\ "If you quit this using :q, then a temp file will remain in the \n".
		\ "present directory\n".
		\ "================================================================="
	$put=footer

	set nomodified

endfunction 

" }}}
" Darcs_DeleteTempFile: deletes temp file created during commit session {{{
function! Darcs_DeleteTempFile(fname)
	call Darcs_Debug('+Darcs_DeleteTempFile: fname = '.a:fname.', bufnr = '.bufnr(a:fname))
	if bufnr(a:fname) > 0
		execute 'bdelete! '.bufnr(a:fname)
	endif
	let sysout = Darcs_System('rm '.a:fname)
endfunction 

" }}}

" }}}

" ==============================================================================
" Helper functions
" ==============================================================================
" Darcs_System: runs a system command escaping quotes {{{

" By default we will use python if available.
if !exists('g:Darcs_UsePython')
	let g:Darcs_UsePython = 1
endif

function! Darcs_System(syscmd)
	if has('python') && g:Darcs_UsePython == 1
		execute 'python pySystem(r"""'.a:syscmd.'""")'
		return retval
	else
		if &shellxquote =~ '"'
			return system(escape(a:syscmd, '"'))
		else
			return system(a:syscmd)
		endif
	endif
endfunction 

if has('python') && g:Darcs_UsePython == 1
python << EOF

import vim, os, re

def pySystem(command):
	(cstdin, cstdout) = os.popen2(command)

	out = cstdout.read()

	vim.command("""let retval = "%s" """ % re.sub(r'"|\\', r'\\\g<0>', out))

EOF
endif

" }}}
" Darcs_CD: cd's to a directory {{{
function! Darcs_CD(dirname)
	execute "cd ".escape(a:dirname, ' ')
endfunction

" }}}
" Darcs_OpenScratchBuffer: opens a scratch buffer {{{
function! Darcs_OpenScratchBuffer()
	new
	set buftype=nofile
	set noswapfile
	set filetype=
endfunction

" }}}
" Darcs_NoteViewState: notes the current fold related settings of the buffer {{{
function! Darcs_NoteViewState()
	let b:darcs_old_diff         = &l:diff 
	let b:darcs_old_foldcolumn   = &l:foldcolumn
	let b:darcs_old_foldenable   = &l:foldenable
	let b:darcs_old_foldmethod   = &l:foldmethod
	let b:darcs_old_scrollbind   = &l:scrollbind
	let b:darcs_old_wrap         = &l:wrap
endfunction

" }}}
" Darcs_ResetViewState: restores the fold related settings of a buffer {{{
function! Darcs_ResetViewState()
	let &l:diff         = b:darcs_old_diff 
	let &l:foldcolumn   = b:darcs_old_foldcolumn
	let &l:foldenable   = b:darcs_old_foldenable
	let &l:foldmethod   = b:darcs_old_foldmethod
	let &l:scrollbind   = b:darcs_old_scrollbind
	let &l:wrap         = b:darcs_old_wrap
endfunction

nnoremap <Plug>DarcsRestoreViewAndQuit :q<CR>:call Darcs_ResetViewState()<CR>:<BS> 

" }}}
" Darcs_GetTempName: get the name of a temporary file in specified directory {{{
" Description: Unlike vim's native tempname(), this function returns the name
"              of a temporary file in the directory specified. This enables
"              us to create temporary files in a specified directory.
function! Darcs_GetTempName(dirname)
	let prefix = 'darcsVimTemp'
	let slash = (a:dirname =~ '\\\|/$' ? '' : '/')
	let i = 0
	while filereadable(a:dirname.slash.prefix.i.'.tmp') && i < 1000
		let i = i + 1
	endwhile
	if filereadable(a:dirname.slash.prefix.i.'.tmp')
		echoerr "Temporary file could not be created in ".a:dirname
		return ''
	endif
	return expand(a:dirname.slash.prefix.i.'.tmp', ':p')
endfunction
" }}}
" Darcs_SetSilent: sets options to make vim "silent" {{{
function! Darcs_SetSilent(isSilent)
	if a:isSilent == 'silent'
		let s:_showcmd = &showcmd
		let s:_lz = &lz
		let s:_report = &report
		set noshowcmd
		set lz
		set report=999999
	else
		let &showcmd = s:_showcmd
		let &lz = s:_lz
		let &report = s:_report
	endif
endfunction " }}}
" Darcs_Debug: appends the argument into s:debugString {{{
if !exists('g:Darcs_Debug')
	let g:Darcs_Debug = 1
	let s:debugString = ''
endif
function! Darcs_Debug(str)
	let s:debugString = s:debugString.a:str."\n"
endfunction " }}}
" Darcs_PrintDebug: prings s:debugString {{{
function! Darcs_PrintDebug()
	echo s:debugString
endfunction " }}}
" Darcs_ClearDebug: clears the s:debugString string {{{
function! Darcs_ClearDebug(...)
	let s:debugString = ''
endfunction " }}}

" vim:fdm=marker
