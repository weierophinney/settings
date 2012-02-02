" Vim syntax file
" Begin my settings!

" Automatically reload .vimrc when changing
autocmd! bufwritepost .vimrc source! %

" Disable the splash screen
:set shortmess +=I

" Enable pathogen bundles
" See http://www.vim.org/scripts/script.php?script_id=2332
" Put github plugins under .vim/bundle/ -- which allows keeping them updated
" without having to do separate installation.
" Call "filetype off" first to ensure that bundle ftplugins can be added to the
" path before we re-enable it later in the vimrc.
:filetype off
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()

" Added 2010-09-21 Based on http://stevelosh.com/blog/2010/09/coming-home-to-vim
" Set mapleader to ","
let mapleader = ","

" vimcasts #24
" Auto-reload vimrc on save
if has("autocmd")
    autocmd bufwritepost .vimrc source $MYVIMRC
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
:set tabstop=4
:set softtabstop=4
:set shiftwidth=4
:set number
:set background=dark
:syntax on
:set tags=$HOME/.vim/doc/tags
:set ttyfast
:set showcmd
:set showmode
:set wildmenu
:set wildmode=list:longest

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

" Turn on "very magic" regex status by default for searches.
" :he /magic for more information
:nnoremap / /\v
:vnoremap / /\v

" Folding -- allows me to toggle display of comment lines
" Then, do a :g/^\s*#/,/^\s*[^#]/-fold
:set foldenable foldmethod=manual

" new folding options 2005-05-21
":set foldenable foldmethod=marker
":set foldclose=all

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

" HTML tag closing macro
:let g:closetag_html_style=1
:autocmd Filetype html source $HOME . "/.vim/closetag.vim"

" PHP options
:function! PhpDocLoad()
:   so $HOME/.vim/php-doc.vim
:   inoremap <C-P><ESC> :call PhpDocSingle()<CR>i
:   nnoremap <C-P> :call PhpDocSingle()<CR>
:   vnoremap <C-P> :call PhpDocRange()<CR>
:   inoremap ( ()<Left>
:endfunction

" Set keywordprg to use pman in PHP files
:autocmd FileType php set keywordprg=/usr/local/zend/bin/pman

" Add xdebug2 dictionary when in PHP files
:autocmd FileType php set dictionary+=~/.vim/dic/xdebug2

" Load a tag file
" Loads a tag file from ~/.vim.tags/, based on the argument provided. The
" command "Ltag"" is mapped to this function.
:function! LoadTags(file)
:   let tagspath = $HOME . "/.vim.tags/" . a:file
:   let tagcommand = 'set tags+=' . tagspath
:   execute tagcommand
:endfunction
:command! -nargs=1 Ltag :call LoadTags("<args>")

" These are tag files I've created; you may want to remove/change these for your
" own usage.
:call LoadTags("zf1")
:call LoadTags("zf2")
:call LoadTags("phpunit")

" PHP syntax settings
:let php_sql_query=1
:let php_htmlInStrings=1
:let php_folding=1
:let php_parent_error_close=1
:let php_parent_error_open=1
:autocmd BufNewFile,BufRead *.php call PhpDocLoad()

" PHP parser check (CTRL-L)
:autocmd FileType php noremap <C-L> :w!<CR>:!$HOME/bin/php -l %<CR>

" run file with PHP CLI (CTRL-M)
:autocmd FileType php noremap <C-M> :w!<CR>:!$HOME/bin/php %<CR>

" run file using PHPUnit (Leader-u)
:autocmd FileType php noremap <Leader>u :w!<CR>:!!$HOME/bin/phpunit %<CR>

" Run file with Ruby interpreter
:autocmd FileType ruby noremap <C-M> :w!<CR>:!ruby %<CR>

" Search phpm for function name under cursor (CTRL-H)
":inoremap <C-H> <ESC>:!phpm -e <C-R>=expand("<cword>")<CR><CR>
":nnoremap <C-H> <ESC>:!phpm -e <C-R>=expand("<cword>")<CR><CR>

" JSLint (CTRL-L when in a JS file)
:autocmd FileType javascript noremap <C-L> :!/home/matthew/bin/jslint %<CR>

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

" The escape key is a long ways away. This maps it to the sequence ';;'
:map! jj <esc>

" Similarly, : takes two keystrokes, ; takes one; map the latter to the former
" in normal mode to get to the commandline faster
nnoremap ; :

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

" Turn on modelines
:set modeline
:set modelines=4

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

" Comment options
:set formatoptions=qroctn2
:set colorcolumn=80

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

" Disable spellcheck
" let spell_auto_type = ""

" Map <S-F5> to turn spelling on (VIM 7.0+)
map <S-F5> :setlocal spell spelllang=en_us<cr>

" Use UTF-8 encoding
:set encoding=utf-8

" Show info in ruler
set laststatus=2

" Scrolling options
set scrolljump=5
set scrolloff=3

" NERDTree options
:let NERDChristmasTree=1
:let NERDTreeCaseSensitiveSort=1
:let NERDTreeChDirMode=2
:let NERDTreeBookmarksFile = $HOME . "/.vim/NERDTreeBookmarks"
:let NERDTreeShowBookmarks=1
:let NERDTreeShowHidden=1
:let NERDTreeQuitOnOpen=0
:map <Leader>n :NERDTree<CR>

" vimwiki options
:let g:vimwiki_list = [{'path': '~/mydocs/wiki/'}]

" Color scheme
" First line ensures we can have full spectrum of colors
:set t_Co=256
" :let g:solarized_termcolors=256
:colorscheme solarized

" ACK support
:set grepprg=ack-grep\ -a
:let g:ackprg="ack-grep -H --nocolor --nogroup --column"
:map <Leader>g :Ack

" snipMate options
let g:snips_author = "Matthew Weier O'Phinney"
let g:snippets_dir = $HOME . "/.vim/snippets/"

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
nnoremap <leader>f <C-w>s<C-w>j
" and use <ctrl> plus direction key to move around within windows
" nnoremap <C-h> <C-w>h
" nnoremap <C-j> <C-w>j
" nnoremap <C-k> <C-w>k
" nnoremap <C-l> <C-w>l

" Added 2010-10-23: Include git branch, if available, in status line
" This one is for the git-vim plugin:
":set statusline=%<%{GitBranch()}:%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P
" This one is for the vim-fugitive plugin:
:set statusline=%<%f\ %h%m%r%{fugitive#statusline()}%=%-14.(%l,%c%V%)\ %P

" Added 16-Jun-2011: auto-cleans fugitive buffers
" From http://vimcasts.org/episodes/fugitive-vim-browsing-the-git-object-database/
autocmd BufReadPost fugitive://* set bufhidden=delete

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

" vim-powerline settings
let g:Powerline_symbols="unicode"
let g:Powerline_cache_file="/home/matthew/tmp/Powerline-vim.cache"

" syntastic settings
let g:syntastic_check_on_open=0
let g:syntastic_auto_jump=1
let g:syntastic_auto_loc_list=1
let g:syntastic_mode_map = { 'mode': 'active',
                           \ 'active_filetypes': ['php', 'javascript', 'JSON', 'html', 'sh', 'docbook', 'css', 'xml', 'xhtml'] }
