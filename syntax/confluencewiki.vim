"============================================================================
"
" Confluence WIKI syntax file
"
" Language:    Confluence WIKI
" Version:     0.0.2
" Maintainer:  Daniel Graña <daniel{AT}insophia{DOT}com>
" License:     GPL (http://www.gnu.org/licenses/gpl.txt)
"    Copyright (C) 2004  Rainer Thierfelder
"
"    This program is free software; you can redistribute it and/or modify
"    it under the terms of the GNU General Public License as published by
"    the Free Software Foundation; either version 2 of the License, or
"    (at your option) any later version.
"
"    This program is distributed in the hope that it will be useful,
"    but WITHOUT ANY WARRANTY; without even the implied warranty of
"    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
"    GNU General Public License for more details.
"
"    You should have received a copy of the GNU General Public License
"    along with this program; if not, write to the Free Software
"    Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA
"
"============================================================================
"
" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if !exists("main_syntax")
  if version < 600
    syntax clear
  elseif exists("b:current_syntax")
    finish
  endif
  let main_syntax = 'confluencewiki'
endif

" Don't use standard HiLink, it will not work with included syntax files
if version < 508
  command! -nargs=+ ConfluenceHiLink   highlight link <args>
  command! -nargs=+ ConfluenceSynColor highlight <args>
else
  command! -nargs=+ ConfluenceHiLink   highlight default link <args>
  command! -nargs=+ ConfluenceSynColor highlight default <args>
endif

"============================================================================
" Group Definitions:    
"============================================================================

" Emphasis:  
function! s:ConfluenceCreateEmphasis(token, name)
    execute 'syntax region confluence'.a:name.
           \' oneline start="\(^\|[ ]\)\zs'.a:token.
           \'" end="'.a:token.'\ze\([,. ?):-]\|$\)"'
endfunction

syntax region confluenceFixed oneline start="\(^\|[ ]\)\zs{{" end="}}\ze\([,. ?):-]\|$\)"

call s:ConfluenceCreateEmphasis('+', 'Underlined')
call s:ConfluenceCreateEmphasis('\*', 'Bold')
call s:ConfluenceCreateEmphasis('_',  'Italic')
call s:ConfluenceCreateEmphasis('-', 'Strike')


" Syntax:  
syntax match confluenceDelimiter "|"
syntax match confluenceSeparator    "^----*"
syntax match confluenceList "^[*#]\+\ze "
syntax match confluenceSingleList "^-\ze "

"syntax match confluenceVariable "\([^!]\|^\)\zs%\w\+%"

" tag support is a limited to no white spaces in tag parameters
syntax match confluenceTag      "{\w\+\(:\(\w\+=\?[a-zA-Z0-9 ]\+|\?\)*\)\?}"

syntax region confluenceComment  start="{HTMLcomment\(:hidden\)\?}" end="{HTMLcomment}"

syntax region confluenceCode matchgroup=confluenceCode
    \ start="{code}" end="{code}"

syntax region confluenceQuote matchgroup=confluenceQuote
    \ start="{quote}" end="{quote}"

syntax region confluenceVerbatim matchgroup=confluenceVerbatim
    \ start="{noformat}" end="{noformat}"

syntax region confluenceHeading matchgroup=confluenceHeadingMarker oneline
    \ start="^h[1-9]. " end="$"

let s:wikiWord = '\u[a-z0-9]\+\(\u[a-z0-9]\+\)\+'

execute 'syntax match confluenceAnchor +^#'.s:wikiWord.'\ze\(\>\|_\)+'
execute 'syntax match confluenceWord +\(\s\|^\)\zs\(\u\l\+\.\)\='.s:wikiWord.'\(#'.s:wikiWord.'\)\=\ze\(\>\|_\)+'
" Regex guide:                   ^pre        ^web name       ^wikiword  ^anchor               ^ post

" Links: 
syntax region confluenceLink matchgroup=confluenceLinkMarker
    \ start="\( \|^\)\zs\[" end="\]\ze\([,. ?):-]\|$\)"
    \ contains=confluenceForcedLink,confluenceLinkRef keepend

execute 'syntax match confluenceForcedLink +[ A-Za-z0-9]\+\(#'.s:wikiWord.'\)\=+ contained'

syntax match confluenceLinkLabel    ".\{-}\ze\["
    \ contained contains=confluenceLinkMarker nextgroup=confluenceLinkLabel
syntax match confluenceLinkRef  ".\{-}\ze\]"   contained contains=confluenceLinkMarker
syntax match confluenceLinkMarker "|"           contained

"============================================================================
" Group Linking:    
"============================================================================

ConfluenceHiLink confluenceHeading       String
ConfluenceHiLink confluenceHeadingMarker Operator
ConfluenceHiLink confluenceVariable      PreProc
ConfluenceHiLink confluenceTag           PreProc
ConfluenceHiLink confluenceQuote         PreProc
ConfluenceHiLink confluenceComment       Comment
ConfluenceHiLink confluenceWord          Tag
ConfluenceHiLink confluenceAnchor        PreProc
ConfluenceHiLink confluenceVerbatim      Constant
ConfluenceHiLink confluenceCode          Constant
ConfluenceHiLink confluenceList          Operator
ConfluenceHiLink confluenceSingleList    Operator

ConfluenceHiLink confluenceDelimiter     Operator

" Links
ConfluenceSynColor confluenceLinkMarker term=bold cterm=bold gui=bold
ConfluenceHiLink   confluenceForcedLink Tag
ConfluenceHiLink   confluenceLinkRef    Tag
ConfluenceHiLink   confluenceLinkLabel  Identifier

" Emphasis
ConfluenceSynColor confluenceFixed      term=underline cterm=underline gui=underline
ConfluenceSynColor confluenceItalic     term=italic cterm=italic gui=italic
ConfluenceSynColor confluenceBold       term=bold cterm=bold gui=bold
ConfluenceSynColor confluenceSingleList term=bold cterm=bold gui=bold

"============================================================================}" Clean Up:    {{{1
"============================================================================

delcommand ConfluenceHiLink
delcommand ConfluenceSynColor

if main_syntax == 'confluencewiki'
  unlet main_syntax
endif

let b:current_syntax = "confluencewiki"

" vim:fdm=marker
