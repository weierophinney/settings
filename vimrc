" Vim syntax file
" Begin my settings!

" Automatically reload .vimrc when changing
" autocmd! bufwritepost .vimrc source! %

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

" I like tabstops of 4, and prefer spaces to tabs. I want the text width to be
" 80, and for it to wrap. My default background is dark. I like syntax
" highlighting.
:set nocompatible
:set expandtab
:set textwidth=80
:set tabstop=4
:set softtabstop=4
:set shiftwidth=4
:set background=dark
:syntax on
:set tags=$HOME/.vim/doc/tags

" Added 2005-03-23 Based on http://www.perlmonks.org/index.pl?node_id=441738
:set smarttab
:set shiftround
:set autoindent
:set smartindent

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

" Note: The normal command afterwards deletes an ugly pending line and moves
" the cursor to the middle of the file.
autocmd BufNewFile *.php 0r ~/.vim/skeleton.php | normal Gdd

" Highlight Searches
:set highlight=lub
:map <Leader>s :set hlsearch<CR>
:map <Leader>S :set nohlsearch<CR>
:set incsearch

" HTML tag closing macro
:let g:closetag_html_style=1
:autocmd Filetype html source $HOME/.vim/closetag.vim

" PHP options
:function! PhpDocLoad()
:   so $HOME/.vim/php-doc.vim
:   inoremap <C-P><ESC> :call PhpDocSingle()<CR>i
:   nnoremap <C-P> :call PhpDocSingle()<CR>
:   vnoremap <C-P> :call PhpDocRange()<CR>
:   inoremap ( ()<Left>
:endfunction

" Create accessors for a variable
" Creates accessors for accvar, making the assumption that accvar is protected.
:function! PhpAccessor(accvar)
:   let uCased = substitute(a:accvar, "^.", "\\U\\0", "")
:   let protected = '_' . a:accvar
:   let getDocTag = "    /**\n     * Retrieve " . a:accvar . "\n     *\n     * @return mixed\n     */\n"
:   let getFunc = "    public function get" . uCased . "()\n    {\n        return $this->" . protected . ";\n    }\n\n"
:   let setDocTag = "    /**\n     * Set " . a:accvar . "\n     *\n     * @param mixed $value\n     * @return self\n     */\n"
:   let setFunc = "    public function set" . uCased . "($value)\n    {\n        $this->" . protected . " = $value;\n        return $this;\n    }\n\n"
:   let @z = getDocTag . getFunc . setDocTag . setFunc
:   put! z
:endfunction
:command! -nargs=1 Pset :call PhpAccessor("<args>")

" Load a tag file
" Loads a tag file from ~/.vim.tags/, based on the argument provided. The
" command "Ltag"" is mapped to this function.
:function! LoadTags(file)
:   let tagspath = $HOME . "/.vim.tags/" . a:file
:   let tagcommand = 'set tags+=' . tagspath
:   execute tagcommand
:endfunction
:command! -nargs=1 Ltag :call LoadTags("<args>")
" These are tag files I've created
:call LoadTags("zf1")
:call LoadTags("zf2")
:call LoadTags("phpunit")

:let php_sql_query=1
:let php_htmlInStrings=1
:let php_folding=1
:let php_parent_error_close=1
:let php_parent_error_open=1
:autocmd BufNewFile,BufRead *.php call PhpDocLoad()

" PHP parser check (CTRL-L)
:autocmd FileType php noremap <C-L> :!$HOME/bin/php -l %<CR>

" run file with PHP CLI (CTRL-M)
:autocmd FileType php noremap <C-M> :w!<CR>:!$HOME/bin/php %<CR>

" Run file with Ruby interpreter
:autocmd FileType ruby noremap <C-M> :w!<CR>:!ruby %<CR>

" Search phpm for function name under cursor (CTRL-H)
":inoremap <C-H> <ESC>:!phpm -e <C-R>=expand("<cword>")<CR><CR>
":nnoremap <C-H> <ESC>:!phpm -e <C-R>=expand("<cword>")<CR><CR>

" JSLint (CTRL-L)
:autocmd FileType javascript noremap <C-L> :!/home/matthew/bin/jslint %<CR>

" Make a print macro
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

" HTML::Template, Smarty files
:autocmd BufNewFile,BufRead *.templ set ft=html
:autocmd BufNewFile,BufRead *.tmpl set ft=html
:autocmd BufNewFile,BufRead *.tpl set ft=html

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

" Repair weird terminal/vim settings
:set backspace=start,eol,indent

" Bash is my shell
:let bash_is_sh=1

" Mail options
" Normalize comments
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
" :nmap <C-t> :tabnew<CR>
" :imap <C-t> <ESC>:tabnew<CR>
" :nmap <C-w> :tabclose<CR>
" :imap <C-w> <ESC>:tabclose<CR>

" Disable spellcheck
" let spell_auto_type = ""

" Map <F5> to turn spelling on (VIM 7.0+)
map <F5> :setlocal spell! spelllang=en_us<cr>

" Use UTF-8 encoding
:set encoding=utf-8

" Highlight current line in insert mode.
" autocmd InsertLeave * se nocul
" autocmd InsertEnter * se cul 

" Show info in ruler
set laststatus=2

set scrolljump=5
set scrolloff=3

" NERDTree
:let NERDChristmasTree=1
:let NERDTreeCaseSensitiveSort=1
:let NERDTreeChDirMode=2
:let NERDTreeBookmarksFile = $HOME . "/.vim/NERDTreeBookmarks"
:let NERDTreeShowBookmarks=1
:let NERDTreeShowHidden=1
:let NERDTreeQuitOnOpen=1

" vimwiki
:let g:vimwiki_list = [{'path': '~/mydocs/wiki/'}]

" Color scheme
" First line ensures we can have full spectrum of colors
:set t_Co=256
:colorscheme elflord

" ACK support
:set grepprg=ack-grep\ -a

" snipMate
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
\      'get':"/**\n * Get XXXX\n *\n * @return mixed\n */\npublic function getXXXX()\n{\n}\n\n",
\      'set':"/**\n * Set XXXX\n *\n * @param  mixed $value\n * @return mixed\n */\npublic function setXXXX($value)\n{\n    $this->_XXXX = $value;\n    return $this;\n}\n\n"
\    }
\  }
\}
let g:user_zen_expandabbr_key = '<c-y>'
let g:user_zen_complete_tag = 1

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

" vimcasts #26: bubbling text
" Modified to use unimpaired.vim (:he unimpaired)
" Bubble single lines
" nmap <C-k> ddkP
" nmap <C-j> ddp
nmap <C-k> [e
nmap <C-j> ]e
" " Bubble multiple lines
" vmap <C-k> xkP`[V`]
" vmap <C-j> xp`[V`]
vmap <C-k> [e`[V`]
vmap <C-j> ]e`[V`]

" TagList settings
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
