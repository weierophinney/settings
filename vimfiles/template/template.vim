¿"Vim Template, Luc Hermitte, 21st feb 2002 ¿
"=============================================================================
" File:		¡expand("%")¡
" Author:	¡g:author¡
" Version:	«version»
" Created:	¡strftime('%c')¡
" Last Update:	
"------------------------------------------------------------------------
" Description:	«description»
" 
"------------------------------------------------------------------------
" Installation:	«install details»
" History:	«history»
" TODO:		«missing features»
"=============================================================================
"
¿let s:ftplug = confirm("Is this script an ftplugin ?", "&Yes\n&No", 2) == 1 ¿
¿let s:fn = substitute(expand("%"),'\W', '_', 'g') ¿
" Avoid reinclusion
¡s:ftplug ? "if exists('b:loaded_ftplug_". s:fn."') | finish | endif" : ""¡
¡s:ftplug ? "let b:loaded_ftplug_".s:fn." = 1" : "" ¡
¡s:ftplug ? '"' : "" ¡
¿if s:ftplug | exe "normal a\"\r\<esc>73a-\<esc>D" | endif ¿
¡s:ftplug ? '"' : "" ¡
¡s:ftplug ? "«Buffer relative definitions»" : "" ¡
¡s:ftplug ? " " : "" ¡
" 
¿if s:ftplug | exe "normal a\"\r\<esc>78a=\<esc>D" | endif ¿
if exists("g:loaded_¡s:fn¡") | finish | endif
let g:loaded_¡s:fn¡ = 1
"
"------------------------------------------------------------------------
"
«Global definitions -- like functions»
