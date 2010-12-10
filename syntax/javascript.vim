" Vim syntax file
" Language:     JavaScript
" Maintainer:   Yi Zhao <zzlinux AT hotmail DOT com>
" Last Change:  2006 March 20
" Version:      0.5
" Based On:     javascript.vim from Claudio Fleiner <claudio@fleiner.com>
" Changes:      export @htmlJavaScript to html.vim
"
" TODO
"   - internal function hightlight
"

if !exists("main_syntax")
  if version < 600
    syntax clear
  elseif exists("b:current_syntax")
    finish
  endif
  let main_syntax = 'javascript'
endif

" Drop fold if it set but vim doesn't support it.
if version < 600 && exists("javaScript_fold")
  unlet javaScript_fold
"else
"  let javaScript_fold = 'true'
endif

syntax case match

syntax match   jsSpecial        "\\\d\d\d\|\\x[0-9a-fA-F]\{2\}\|\\u[0-9a-fA-F]\{4\}\|\\."
syntax region  jsStringD        start=+"+  skip=+\\\\\|\\$"+  end=+"+  contains=jsSpecial,@htmlPreproc
syntax region  jsStringS        start=+'+  skip=+\\\\\|\\$'+  end=+'+  contains=jsSpecial,@htmlPreproc
syntax region  jsRegexpString   start=+/\(\*\|/\)\@!+ skip=+\\\\\|\\/+ end=+/[gim]*\(\s*[),.;$]\)\@=+ contains=jsSpecial,@htmlPreproc oneline
syntax match   jsNumber         "-\=\<\d\+L\=\>\|0[xX][0-9a-fA-F]\+\>"

syntax keyword jsCommentTodo    TODO FIXME XXX TBD contained
syntax region  jsLineComment    start=+\/\/+ end=/$/ contains=jsCommentTodo oneline
syntax region  jsComment        start="/\*"  end="\*/" contains=jsCommentTodo,jsLineComment fold

syntax match   jsLabel          /\(?\s*\)\@<!\<\w\+\(\s*:\)\@=/

"" Programm Keywords
syntax keyword jsSource         import export
syntax keyword jsType           this var const void 
syntax keyword jsOperator       delete new in instanceof typeof 
syntax keyword jsBoolean        true false
syntax keyword jsNull           null

"" Statement Keywords
syntax keyword jsConditional    if else
syntax keyword jsRepeat         do while for
syntax keyword jsBranch         break continue switch case default return 
syntax keyword jsStatement      try catch throw with 

syntax keyword jsGlobalObjects  Array Boolean Date Error Function java JavaArray JavaClass JavaObject JavaPackage Math netscape Number Object Packages RegExp String sun

syntax sync fromstart
syntax sync maxlines=100

" Code blocks
syntax cluster jsAll       contains=jsComment,jsLineComment,jsSpecial,jsStringD,jsStringS,jsNumber,jsRegexpString,jsBoolean,jsFunction,jsConditional,jsRepeat,jsBranch,jsOperator,jsType,jsStatement,jsBoolean,jsGlobalObjects
syntax region  jsBracket   matchgroup=jsBracket transparent start="\[" end="\]" contains=@jsAll,jsBracket,jsParen,jsBlock
syntax region  jsParen     matchgroup=jsParen transparent start="(" end=")" contains=@jsAll,jsParen,jsBracket,jsBlock
syntax region  jsBlock     matchgroup=jsBlcok transparent start="{" end="}" contains=ALL 

" catch errors caused by wrong parenthesis
syntax match   jsParenError  ")\|}\|\]"

if main_syntax == "javascript"
  syntax sync ccomment jsComment
endif

if exists("javaScript_fold")
    syntax match  jsFunction            /\<function\>/
    syntax match  jsFuncFoldStart       /\([=:^]\s*\)\@<=\<function\>\(\s*\w*\s*\)\@=/ nextgroup=jsFuncFoldParen skipwhite fold
    syntax region jsFuncFoldParen       start="(" end=")" contained nextgroup=jsFuncBlock skipwhite contains=@jsAll,jsParen fold
    syntax region jsFuncFoldBlock       start="{" end="}\([\s;]*$\)\@=" skipwhite contains=ALL contained fold

    syntax sync match jsSync    grouphere jsFuncFoldBlock "\<function\>"
    syntax sync match jsSync    grouphere NONE "^}"

    setlocal foldmethod=syntax
    setlocal foldtext=getline(v:foldstart)
else
    syntax keyword    jsFunction        function
endif

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_javascript_syn_inits")
  if version < 508
    let did_javascript_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif
  HiLink jsComment              Comment
  HiLink jsLineComment          Comment
  HiLink jsCommentTodo          Todo
  HiLink jsStringS              String
  HiLink jsStringD              String
  HiLink jsRegexpString         String
  HiLink jsCharacter            Character
  HiLink jsConditional          Conditional
  HiLink jsBranch               Conditional
  HiLink jsRepeat               Repeat
  HiLink jsStatement            Statement
  HiLink jsFunction             Function
  HiLink jsBlock                Function
  HiLink jsError                Error
  HiLink jsParenError           Error
  HiLink jsOperator             Operator
  HiLink jsType                 Type
  HiLink jsNull                 Type
  HiLink jsNumber               Number
  HiLink jsBoolean              Boolean
  HiLink jsLabel                Label
  HiLink jsSpecial              Special
  HiLink jsSource               Special
  HiLink jsGlobalObjects        Special
  delcommand HiLink
endif

" Define the htmlJavaScript for HTML syntax html.vim
syntax cluster htmlJavaScript contains=@jsAll,jsBracket,jsParen,jsBlock,jsParenError
" Removing javaScriptExpression, while it didn't work because we are loaded first.
"syntax clear javaScriptExpression

let b:current_syntax = "javascript"
if main_syntax == 'javascript'
  unlet main_syntax
endif

" vim: ts=4
