" Vim syntax file
" Begin my settings!

" Disable the splash screen
:set shortmess +=I

" Enable pathogen bundles
" See http://www.vim.org/scripts/script.php?script_id=2332
" Put github plugins under .vim/bundle/ -- which allows keeping them updated
" without having to do separate installation.
" Call "filetype off" first to ensure that bundle ftplugins can be added to the
" path before we re-enable it later in the vimrc.
:filetype off
call pathogen#infect()
call pathogen#helptags()

" Added 2010-09-21 Based on http://stevelosh.com/blog/2010/09/coming-home-to-vim
" Set mapleader to ","
let mapleader = ","

" vimcasts #24
" Auto-reload vimrc on save
if has("autocmd")
    autocmd bufwritepost .vimrc source $MYVIMRC
    filetype plugin indent on
endif
" Load vimrc in new tab with leader-v
nmap <leader>v :tabedit $MYVIMRC<CR>

" "Hidden" buffers -- i.e., don't require saving before editing another file.
" Calling quit will prompt you to save unsaved buffers anyways.
:set hidden

" I like tabstops of 4, and prefer spaces to tabs. I want the text width to be
" 80, and for it to wrap. My default background is dark. I like syntax
" highlighting.
:set nocompatible
:set encoding=utf-8
:set expandtab
:set textwidth=80
set colorcolumn=80
:set tabstop=4
:set softtabstop=4
:set shiftwidth=4
:set number
:set background=dark
:syntax on
:set ttyfast
:set showcmd
:set showmode
:set wildmenu
:set wildmode=list:longest
:set undofile
:set splitbelow
:set splitright

" Remap F1 to escape, because that happens a lot when reaching. :)
inoremap <F1> <ESC>
nnoremap <F1> <ESC>
vnoremap <F1> <ESC>

" " Via https://twitter.com/vimtips/status/208241766816677889
" " Allows all operations to work with system clipboard
" :set clipboard=unnamed

" This setting can be useful for determining how many lines of text you want to
" yank. It will display the line number column, but lines will be the distance
" from the current line.
":set relativenumber

" Added 2005-03-23 Based on http://www.perlmonks.org/index.pl?node_id=441738
:set smarttab
:set shiftround
:set autoindent
:set smartindent

" "sudo" save:
:cmap w!! w !sudo tee % >/dev/null

" This is for mouse scrolling (primarily in GVIM)
:map <M-Esc>[62~ <MouseDown>
:map! <M-Esc>[62~ <MouseDown>
:map <M-Esc>[63~ <MouseUp>
:map! <M-Esc>[63~ <MouseUp>
:map <M-Esc>[64~ <S-MouseDown>
:map! <M-Esc>[64~ <S-MouseDown>
:map <M-Esc>[65~ <S-MouseUp>
:map! <M-Esc>[65~ <S-MouseUp>

" This _may_ be needed to allow scrolling within tmux
" :set ttymouse=xterm2

" Turn on "very magic" regex status by default for searches.
" :he /magic for more information
:nnoremap / /\v
:vnoremap / /\v

" Execute last command over a visual selection
:vnoremap . :norm.<CR>

" Folding
" Toggle folding with spacebar instead of za
nnoremap <Space> za

" Pasting toggle...
:set pastetoggle=<Ins>

" Local scripts/helpfiles
:helptags $HOME/.vim/doc

" Skeleton (template) files...
:autocmd BufNewFile *.html 0r $HOME/.vim/skeleton.html

" Note: The "normal" command afterwards deletes an ugly pending line and moves
" the cursor to the middle of the file.
autocmd BufNewFile *.php 0r ~/.vim/skeleton.php | normal Gdd

" Highlight Searches
:set highlight=lub
:map <Leader>s :set hlsearch<CR>
:map <Leader>S :set nohlsearch<CR>
:set incsearch
:set showmatch

" HTML tag closing macro
:let g:closetag_html_style=1
:autocmd Filetype html source $HOME/.vim/closetag.vim"

" 2-space tab-width for HTML
:autocmd FileType html set shiftwidth=2 tabstop=2 softtabstop=2

" 2-space tab-width for CSS
:autocmd FileType css set shiftwidth=2 tabstop=2 softtabstop=2

" Set keywordprg to use pman in PHP files
" Commented out 2017-07-12; do not have pman installed anywhere
" :autocmd FileType php set keywordprg=/usr/local/zend/bin/pman

" Add xdebug2 dictionary when in PHP files
:autocmd FileType php set dictionary+=~/.vim/dic/xdebug2

" PHP syntax settings
:let php_sql_query=1
:let php_htmlInStrings=1
:let php_folding=0
:let php_parent_error_close=1
:let php_parent_error_open=1

" PHP parser check (Leader + L)
:autocmd FileType php noremap <Leader>l :w!<CR>:!php -l %<CR>

" run file with PHP CLI (CTRL-M)
:autocmd FileType php noremap <C-M> :w!<CR>:!php %<CR>

" run file using PHPUnit (Leader-u)
" Commented out 2017-07-12; typically using php-watch now. Also, conflicts with phpactor
" :autocmd FileType php noremap <Leader>u :w!<CR>:!phpunit %<CR>

" Trim trailing whitespace and \r characters
" autocmd FileType c,cpp,java,php,javascript,python,twig,xml,yml,phtml,vimrc autocmd BufWritePre <buffer> :call setline(1,map(getline(1,"$"),'substitute(v:val,"\\s\\+$","","")'))

" Run file with Ruby interpreter
:autocmd FileType ruby noremap <C-M> :w!<CR>:!ruby %<CR>

" Search phpm for function name under cursor (CTRL-H)
":inoremap <C-H> <ESC>:!phpm -e <C-R>=expand("<cword>")<CR><CR>
":nnoremap <C-H> <ESC>:!phpm -e <C-R>=expand("<cword>")<CR><CR>

" JSHint (<Leader> l when in a JS file)
:autocmd FileType javascript noremap <Leader>l :!jshint %<CR>

" 2-space tab-width for JS
:autocmd FileType javascript set shiftwidth=2 tabstop=2 softtabstop=2

" Make a print macro (linux only)
" :map <Leader>p :write !lpr<CR>
:map <Leader>p :hardcopy<CR>

" Syntax highlighting macro
:map <Leader>h :syn on<CR>
:map <Leader>H :syn off<CR>

" Allow Man viewing
source $VIMRUNTIME/ftplugin/man.vim

" Keybindings for movement in insert mode
imap <Leader>0 <Esc>I
imap <Leader>$ <Esc>A
imap <Leader>h <Esc>i
imap <Leader>l <Esc>lli
imap <Leader>j <Esc>lji
imap <Leader>k <Esc>lki

" Replace across buffers script
:so $HOME/.vim/bufreplace.vim

" The escape key is a long ways away. This maps it to the sequence 'kj'
:map! kj <Esc>
:inoremap kj <Esc>

" Turn on filetype plugins
:filetype plugin on
:filetype plugin indent on
:runtime! $HOME/.vim/ftdetect/*.vim

" Format paragraphs
" Use this when writing documents you're going to import into a word
" processor, etc -- gets rid of wrapping.
:map! <Leader>fp :%s/\n\([^\n]\)/ \1/<CR>

" Make case-insensitive search the norm
:set ignorecase
:set smartcase

" Allow better terminal/mouse integration
:set mousemodel=extend

" syntax highlight pod in perl scripts
let perl_include_pod=1
let perl_extended_vars=1
let perl_fold=1
let perl_fold_blocks=1

" Turn off modelines
:set modelines=0

" .inc, phpt, phtml, phps files as PHP
:autocmd BufNewFile,BufRead *.inc set ft=php
:autocmd BufNewFile,BufRead *.phpt set ft=php
:autocmd BufNewFile,BufRead *.phtml set ft=php
:autocmd BufNewFile,BufRead *.phps set ft=php

" Use viminfo
:set viminfo='100,f1,\"1000,:100,/100,h,%

" syntax highlighting for email
:au BufRead,BufNewFile .followup,.article,.letter :set ft=mail

" Remember settings between sessions
:set viminfo='400,f1,"500,h,/100,:100,<500

" Folding commands (normal mode only
" ,,l = loadview; ,,m = mkview
:set viewdir=$HOME/.vim.view/
:nmap  ,,m :mkview!<Cr>
:nmap  ,,l :loadview<Cr>
:autocmd BufWrite * mkview!
:autocmd BufWinEnter *.* silent loadview
" Following will prevent vim from closing folds in a current pane when opening a
" new pane.
" See http://stackoverflow.com/posts/30618494/revisions
:autocmd InsertLeave,WinEnter * setlocal foldmethod=syntax
:autocmd InsertEnter,WinLeave * setlocal foldmethod=manual

" Comment options
:set formatoptions=qroctn2

" Repair weird terminal/vim settings
:set backspace=start,eol,indent

" Bash is my shell
" Well, not really. But this makes CLI integration better.
:let bash_is_sh=1

" Mail options
" Normalize comments (",,c")
:nmap  ,,c :%s/>\([^ ]\)/> \1/g<CR>
:function! MkMail()
:    set ft=mail
:    set tw=72
:endfunction
:nmap <Leader>M :call MkMail()<CR>
:command! MkMail :call MkMail()

" Tab options (as in Vim GUI Tabs)
" <C-t> Opens a new tab, <C-w> closes current tab
" Remember, gt goes to next tab, gT goes to previous; easier than using firefox
" control sequences
" I don't use tabs often, so I've disabled these for now.
" :nmap <C-t> :tabnew<CR>
" :imap <C-t> <ESC>:tabnew<CR>
" :nmap <C-w> :tabclose<CR>
" :imap <C-w> <ESC>:tabclose<CR>

" Map <S-F5> to turn spelling on (VIM 7.0+)
map <S-F5> :setlocal spell spelllang=en_us<cr>

" Use UTF-8 encoding
:set encoding=utf-8

" Show info in ruler
set laststatus=2

" Scrolling options
set scrolljump=5
set scrolloff=3

" netrw options
" Map ,n to open netrw in the current working directory
:map <Leader>n :edit .<CR>
" Hide swap and undo files from netrw
:let g:netrw_list_hide="^\.sw.*$,^\.*\.sw.*$,^\..*\.un[~]$"
" Use tree view by default
" See https://medium.com/@acparas/tips-5c3082a50c07
:let g:netrw_liststyle=3 " 3 means tree-style

" vimwiki options
:let g:vimwiki_list = [{'path': '~/mydocs/wiki/', 'ext': '.wmkd', 'syntax': 'markdown'}]

" Color scheme
" First line ensures we can have full spectrum of colors
:set t_Co=256
" :let g:solarized_termcolors=256
:let g:solarized_termtrans=1
:colorscheme solarized

" ACK support
:set grepprg=ack-grep\ -a
:let g:ackprg="ack-grep -H --nocolor --nogroup --column"
:map <Leader>g :Ack

" snipMate options
let g:snips_author = "Matthew Weier O'Phinney"
:imap <C-T> <Plug>snipMateNextOrTrigger
:smap <C-T> <Plug>snipMateNextOrTrigger

" Highlight current line
" source $HOME/.vim/plugin/highlight_cursor.vim

" ZenCoding
" See http://code.google.com/p/zen-coding/
" This implementation: http://www.vim.com/scripts/script.php?script_id=2981
let g:user_zen_settings = {
\  'php':{
\    'aliases':{
\    },
\    'snippets':{
\      'req':"require_once '';",
\      'inc':"include_once '';",
\      'thr':"throw new Exception();\n",
\    }
\  }
\}
let g:user_zen_expandabbr_key = '<c-y>'
let g:user_zen_complete_tag = 1

" mustache.vim settings
if has("autocmd")
    au  BufnewFile,BufRead *.mustache set syntax=mustache
endif

" Map <leader>f to split horizontally, and move to bottom window
" nnoremap <leader>f <C-w>s<C-w>j
" Use <ctrl> plus direction key to move around within windows
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Added 2010-10-23: Include git branch, if available, in status line
" This one is for the git-vim plugin:
":set statusline=%<%{GitBranch()}:%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P
" This one is for the vim-fugitive plugin:
:set statusline=%<%f\ %h%m%r%{fugitive#statusline()}%=%-14.(%l,%c%V%)\ %P

" The following adds any Syntastic warnings to the status line when the cursor
" is on a line that was flagged.
:set statusline+=%#warningmsg#
:set statusline+=%{SyntasticStatuslineFlag()}
:set statusline+=%*

" Added 16-Jun-2011: auto-cleans fugitive buffers
" From http://vimcasts.org/episodes/fugitive-vim-browsing-the-git-object-database/
autocmd BufReadPost fugitive://* set bufhidden=delete

" Markdown helpers
" <leader>1 creates the ==== lines below a header
" <leader>2 creates the ---- lines below a header
" <leader>3 creates the ^^^^ lines below a header
" Suggested by http://stevelosh.com/blog/2010/09/coming-home-to-vim/
nnoremap <leader>1 yypVr=
nnoremap <leader>2 yypVr-
nnoremap <leader>3 yypVr^
" augroup markdown
"     au!
"     au BufNewFile,BufRead *.md,*.markdown,*.mkd setlocal filetype=markdown
" augroup END

let g:markdown_enable_folding = 1
let g:markdown_enable_spell_checking = 0

" Use 80 character textwidth
:autocmd FileType markdown set textwidth=80

" TagList options
nnoremap <silent> <F8> :TlistToggle<CR>
let Tlist_Use_Right_Window = 1
let Tlist_Compact_Format = 1
let Tlist_Exit_OnlyWindow = 1
let Tlist_GainFocus_On_ToggleOpen = 1
let Tlist_File_Fild_Auto_Close = 1
let Tlist_Inc_Winwidth = 0
let Tlist_Close_On_Select = 1
let Tlist_Process_File_Always = 1
let Tlist_Display_Prototype = 0
let Tlist_Display_Tag_Scope = 1

" paster.vim settings
" These settings will paste to weierophinney.pastebin.com
let g:PASTER_FORMAT = '-d "api_paste_format=textFormat"'
let g:PASTER_TEXT_AREA = "api_paste_code"
let g:PASTER_URI = "http://pastebin.com/api/api_post.php"
let g:PASTER_BROWSER_COMMAND = $HOME . "/bin/chrome"
let g:PASTER_FIXED_ARGUMENTS = '-d "api_dev_key=fa5e9dc272b702d916c887e76deae4cc&api_option=paste"'
let g:nickID = "weierophinney"
let g:PASTER_RESPONSE_FLAG = "^http:"
function! g:Paster_ParseLocationFrom(line)
  let locator = "n/a"

  if (match(a:line, "^http:") > -1)
    let locator = a:line
  endif

  return "Location: ".locator
endfunction

" argumentrewrap binding
nnoremap <silent> <leader>r :call argumentrewrap#RewrapArguments()<CR>

" supertab settings
let g:SuperTabDefaultCompletionType = "context"

" The following are from https://github.com/lvht/phpcd.vim/issues/63 and
" provide supertab integration for phpcd
" List of contexts used for context completion.
let g:SuperTabCompletionContexts = ['s:ContextText', 's:ContextDiscover']

" List of omni completion option names in the order of precedence that they
" should be used if available.
let g:SuperTabContextTextOmniPrecedence = ['&omnifunc', '&completefunc']

" List of variable:completionType mappings.
let g:SuperTabContextDiscoverDiscovery =
    \ ["&completefunc:<c-x><c-u>", "&omnifunc:<c-x><c-o>"]

" Supertab will provide an enhanced longest match support where typing one or
" more letters and hitting tab again while in a completion mode will complete
" the longest common match using the new text in the buffer.
let g:SuperTabLongestEnhanced = 1

" Sets whether or not to pre-highlight the first match when completeopt has the
" popup menu enabled and the 'longest' option as well.
let g:SuperTabLongestHighlight = 1

" <cr> will cancel completion mode preserving the current text.
let g:SuperTabCrMapping = 1

" Supertab will attempt to close vim's completion preview window when the
" completion popup closes (completion is finished or canceled).
let g:SuperTabClosePreviewOnPopupClose = 1

" tabular settings
if exists(":Tabularize")
  nmap <Leader>a= :Tabularize /=<CR>
  vmap <Leader>a= :Tabularize /=<CR>
  nmap <Leader>a: :Tabularize /:\zs<CR>
  vmap <Leader>a: :Tabularize /:\zs<CR>
endif

" GUndo settings
if exists(":GundoToggle")
  nnoremap <F5> :GundoToggle<CR>
endif

" vim-latex settings
let g:tex_flavor='latex'
set iskeyword+=:

" gist-vim settings
let g:gist_clip_command = "xclip -selection clipboard"
let g:gist_detect_filetype = 1
let g:gist_browser_command = $HOME . "/bin/chrome %URL%"
let g:gist_open_browser_after_post = 1
let g:gist_show_privates = 1

" syntastic settings
let g:syntastic_check_on_open=0
let g:syntastic_auto_jump=1
let g:syntastic_auto_loc_list=1
let g:syntastic_mode_map = 
    \ {
        \ 'mode': 'active',
        \ 'active_filetypes': 
            \ [
                \ 'css',
                \ 'docbk',
                \ 'html',
                \ 'javascript',
                \ 'json',
                \ 'php',
                \ 'sh',
                \ 'xhtml',
                \ 'xml'
            \ ]
    \ }

let g:syntastic_css_checkers = ['csslint']
let g:syntastic_javascript_checkers = ['jshint']
let g:syntastic_json_checkers = ['jsonlint']
let g:syntastic_json_jsonlint_args = ['-q -c']
let g:syntastic_php_checkers = ['php', 'phpcs']
let g:syntastic_php_phpcs_args = "--standard=PSR2 -n"

" Disable syntastic on a per buffer basis
function! SyntasticDisable()
    let b:syntastic_skip_checks = 1
    echo 'Syntastic disabled for this buffer'
endfunction

command! SyntasticDisable call SyntasticDisable()

" Inline-Edit
nnoremap <leader>i :InlineEdit<cr>
xnoremap <leader>i :InlineEdit<cr>
inoremap <c-e> <esc>:InlineEdit<cr>a
let g:inline_edit_html_like_filetypes = ['phtml', 'mustache']
let g:inline_edit_patterns = [
    \   {
    \       'main_filetype':    'mkd',
    \       'callback':         'inline_edit#MarkdownFencedCode',
    \   }
    \ ]

" Yank text to the clipboard easier
noremap <leader>y "*y
noremap <leader>yy "*Y

" Preserve indentation while pasting text from the OS X clipboard
noremap <leader>p :set paste<CR>:put  *<CR>:set nopaste<CR>

" phpcomplete.vim settings
" Disabled 2017-07-12 in order to try phpactor
" let g:phpcomplete_complete_for_unknown_classes = 1
" let g:phpcomplete_min_num_of_chars_for_namespace_completion = 1
" let g:phpcomplete_parse_docblock_comments = 1
" let g:phpcomplete_cache_taglists = 1
" let g:phpcomplete_enhance_jump_to_definition = 1
" let g:phpcomplete_mappings =
"     \ {
"     \     'jump_to_def': ',g',
"     \     'jump_to_def_split': '<C-]>',
"     \     'jump_to_def_vsplit': '<C-W><C-]>',
"     \ }

" gutentags settings
let g:gutentags_cache_dir = '~/.vim.gutentags'
" The below was taken from https://robertbasic.com/blog/current-vim-setup-for-php-development/
let g:gutentags_ctags_exclude = ['*.css', '*.html', '*.js', '*.json', '*.xml',
    \ '*.phar', '*.ini', '*.rst', '*.md',
    \ '*vendor/*/test*', '*vendor/*/Test*',
    \ '*vendor/*/fixture*', '*vendor/*/Fixture*',
    \ '*var/cache*', '*var/log*']

" ctrlp settings
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'ra'
" The following are from https://github.com/robertbasic/vimstuff/blob/1b3a2b9483df999efd50e794550fa6ed434ef323/.vimrc#L223-L239
" let g:ctrlp_match_current_file = 1
let g:ctrlp_lazy_update = 1
let g:ctrlp_extensions = ['tag', 'buffertag']
" let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch' }
let g:ctrlp_use_caching = 0
" pair gutentags with ctrlp
map <silent> <leader>jd :CtrlPTag<cr><c-\>w

" airline settings
let g:airline_theme='solarized'
let g:airline#extensions#tagbar#enabled = 1
let g:airline#extensions#tagbar#flags = 'f'

" tagbar-phpctags settings
let g:tagbar_phpctags_bin='~/bin/phpctags'
let g:tagbar_phpctags_memory_limit='512M'

" php.vim overrides
function! PhpSyntaxOverride()
  " highlight annotations better
  hi! def link phpDocTags  phpDefine
  hi! def link phpDocParam phpType
  hi! def link phpDocIdentifier phpIdentifier
endfunction

augroup phpSyntaxOverride
  autocmd!
  autocmd FileType php call PhpSyntaxOverride()
augroup END

" vim-php-namespace
" Map <leader>u to insert a 'use' statement for the class name currently under
" the cursor
" Commented out 2017-07-12; phpactor provides this.
" function! IPhpInsertUse()
"     call PhpInsertUse()
"     call feedkeys('a',  'n')
" endfunction
" autocmd FileType php inoremap <Leader>u <Esc>:call IPhpInsertUse()<CR>
" autocmd FileType php noremap <Leader>u :call PhpInsertUse()<CR>

" Map <leader>e to expand the class name under the cursor to its FQCN
function! IPhpExpandClass()
    call PhpExpandClass()
    call feedkeys('a', 'n')
endfunction
autocmd FileType php inoremap <Leader>e <Esc>:call IPhpExpandClass()<CR>
autocmd FileType php noremap <Leader>e :call PhpExpandClass()<CR>

" Map <leader>s to sort the various 'use' statements
autocmd FileType php inoremap <Leader>s <Esc>:call PhpSortUse()<CR>
autocmd FileType php noremap <Leader>s :call PhpSortUse()<CR>

" Ensure any inserted 'use' statements are sorted correctly
let g:php_namespace_sort_after_insert = 1

" Prompt for and run a command in a tmux pane
let g:VimuxHeight = "25"
let g:VimuxOrientation = "v"
let g:VimuxUseNearest = 0
map <Leader>vp :VimuxPromptCommand<CR>
map <Leader>vl :VimuxRunLastCommand<CR>

" Coffeescript settings
autocmd BufNewFile,BufReadPost *.coffee setl shiftwidth=2 expandtab

" phpactor settings
" Omni-completion
autocmd FileType php setlocal omnifunc=phpactor#Complete

" Include use statement
map <Leader>u :call phpactor#UseAdd()<CR>
map <Leader>o :call phpactor#GotoType()<CR>
map <Leader>pd :call phpactor#OffsetTypeInfo()<CR>
map <Leader>i :call phpactor#ReflectAtOffset()<CR>
map <Leader>pfm :call phpactor#MoveFile()<CR>
map <Leader>pfc :call phpactor#CopyFile()<CR>
map <Leader>tt :call phpactor#Transform()<CR>

" Show information about "type" under cursor including current frame
nnoremap <silent><Leader>d :call phpactor#OffsetTypeInfo()<CR>

" Associate .tsx with typescript filetype
augroup filetypedetect
    au BufRead,BufNewFile *.tsx setfiletype typescript
augroup END
let g:syntastic_typescript_tsc_args = "--jsx preserve --noEmit --experimentalDecorators --lib dom,es2015"
