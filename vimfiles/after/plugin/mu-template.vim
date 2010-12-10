" Author:	Gergely Kontra <kgergely@mcl.hu>
" Last Update:	2002.02.22.
" Version:	0.11
" Description:	Micro vim template file loader
" Installation:	Drop it into your plugin directory
"		If you have some bracketing macros predefined, install this
"		plugin in <$$/after/plugin>
" Usage:	Template file has some magic characters
"		- Strings surrounded by ¡ are expanded by vim
"		  Eg: ¡strftime('%c')¡ will be expanded to the current time
"		  (the time, when the template is read), so
"		  2002.02.20. 14:49:23 on my system NOW.
"		- Strings surrounded by ¿ are interpreted by vim
"		  Eg: ¡let s:fn=expand("%")¡ will affect s:fn with the name of
"		  the file currently created.
"		- Strings between «» signs are fill-out places, or marks, if
"		  you are familiar with some bracketing or jumping macros
"
" History:	0.1	Initial release
"		0.11	- runtimepath is searched for template files,
"			Luc Hermitte <hermitte@free.fr>'s improvements
"			- plugin => non reinclusion
"			- A little installation comment
"			- change 'exe "norm \<c-j>"' to 'norm ¡jump!' + startinsert
"			- add '¿vimExpr¿' to define areas of VimL, ideal to compute
"			  variables
"
" BUGS:
"		Globals should be prefixed. Eg.: g:author
" TODO:		Re-executing commands. (Can be useful for Last Modified
"		fields)
"		Must mark the area watched somehow...
"		Ideas, suggestions?
"========================================================================

if exists("g:mu_template") | fini | en
let g:mu_template = 1

if !exists('$VIMTEMPLATES')
  let rtp=&rtp
  wh strlen(rtp)
    let idx=stridx(rtp,',')
    if idx<0|let idx=65535|en
    let $VIMTEMPLATES=strpart(rtp,0,idx).'/template'
    if isdirectory($VIMTEMPLATES)
      brea
    en
    let rtp=strpart(rtp,idx+1)
  endw
en

"========================================================================
if !strlen(maparg('¡jump!','n')) " if you don't have bracketing macros
  fu! Jumpfunc()
    if !search('«.\{-}»','W') "no more marks
      retu "\<CR>"
    el
      if getline('.')[col('.')]=="»"
	retu "\<Del>\<Del>"
      el
	retu "\<Esc>lvf»\<C-g>"
      en
    en
  endf
  im <C-J> <c-r>=Jumpfunc()<CR>
  nm ¡jump! i<C-J>
  nm <C-J> ¡jump!
  vm <C-J> <Del><C-J>
en

fu! <SID>Exec(what)
  exe 'retu' a:what
endf

" Back-Door to trojans !!!
fu! <SID>Compute(what)
  exe a:what
  retu ""
endf

fu! <SID>Template()
  let ft=strlen(&ft) ? &ft : 'unknown'
  if filereadable($VIMTEMPLATES.'/template.'.ft)
    sil exe '0r '.$VIMTEMPLATES.'/template.'.ft
    sil %s/¿\(\_.[^¿]*\)¿\n\?/\=<SID>Compute(submatch(1))/ge
    sil %s/¡\([^¡]*\)¡/\=<SID>Exec(submatch(1))/ge
    0
    norm ¡jump!
    star
  en
endf

aug template
au BufNewFile * cal <SID>Template()
"au BufWritePre * echon 'TODO'
"au BufWritePre * normal ,last
aug END
