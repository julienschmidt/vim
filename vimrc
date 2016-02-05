" -----------------
" Plugins
" -----------------
execute pathogen#infect()


" -----------------
" General
" -----------------
set nocp                           "enable Vi incompatible features
filetype plugin on                 "per-filetype settings
filetype indent on                 "per-filetype indentation


" ----------------
" Encoding
" ----------------
set encoding=utf-8                 "utf-8 encoding
set termencoding=utf-8             "utf-8 terminal
scriptencoding utf-8
set ff=unix                        "unix line endings


" -----------------
" Theme
" -----------------
" set guifont=Monaco\ for\ Powerline:h12
set background=dark

" load railscasts theme
colorscheme railscasts

highlight SpecialKey ctermfg=darkgreen
highlight SpecialKey guifg=#808080

syntax on                          "syntax highlighting
set nu                             "show line numbers
set ru                             "show ruler at cursor pos
set hlsearch                       "highlight search results
set showmatch                      "matching parentheses

" highlight the word under cursor (CursorMoved is inperformant)
highlight WordUnderCursor cterm=underline "ctermfg=7
autocmd CursorHold * exe printf('match WordUnderCursor /\V\<%s\>/', escape(expand('<cword>'), '/\'))


" ----------------
" Behavior
" ----------------
set ai                             "autoindent
set backspace=indent,eol,start     "allow backspacing over everything in insert mode
set shiftround                     "round > < to shiftwidth
set ignorecase smartcase           "ignore case, except if contains uppercase
set noerrorbells visualbell t_vb=  "don't ring the fucking bell
set incsearch                      "incremental search
set mouse=a                        "enable mouse
set sc                             "show incomplete commmands
set tw=72                          "textwidth 72 characters

autocmd GUIEnter * set visualbell t_vb=

" Tell vim to remember certain things when we exit
"  '10  :  marks will be remembered for up to 10 previously edited files
"  "100 :  will save up to 100 lines for each register
"  :20  :  up to 20 lines of command-line history will be remembered
"  %    :  saves and restores the buffer list
"  n... :  where to save the viminfo files
set viminfo='10,\"100,:20,%,n~/.viminfo

function! RestoreCursorPosition()
    if line("'\"") <= line("$")
        normal! g`"
        return 1
    endif
endfunction

augroup resCur
    autocmd!
    autocmd BufWinEnter * call RestoreCursorPosition()
augroup END


" -----------------
" Autocompletion
" -----------------
let g:neocomplete#enable_at_startup = 1
set wmnu                           "show possible completions



" ----------------
" Whitespace
" ----------------
" font face for bad whitespace
highlight evilws ctermbg=red

" whitespace configuration
function! WhitespaceIndentWidth(x)
    let &l:tabstop     = a:x
    let &l:shiftwidth  = a:x
    let &l:softtabstop = a:x
endfunction

" indent with spaces:
function! WhitespaceSpace(x)
    setlocal expandtab
    call WhitespaceIndentWidth(a:x)

    " tab indent /^\t+\zs/
    " trailing ws /\s\+\%#\@<!$/
    :2match evilws /^\t+\zs\|\s\+\%#\@<!$/
endfunction

" indent with tabs:
function! WhitespaceTab(x)
    setlocal noexpandtab
    call WhitespaceIndentWidth(a:x)

    " space indent /^\t*\zs \+/
    " stray tab /[^\t]\zs\t\+/
    " trailing ws /\s\+\%#\@<!$/
    :2match evilws /^\t*\zs \+\|[^\t]\zs\t\+\|\s\+\%#\@<!$/
endfunction

" default: space indentation with width 4
call WhitespaceSpace(4)

cmap ws2 call WhitespaceSpace(2)
cmap ws4 call WhitespaceSpace(4)
cmap ws8 call WhitespaceSpace(8)
cmap wt4 call WhitespaceTab(4)
cmap wt8 call WhitespaceTab(8)


" -----------------
" Code
" -----------------
"Markdown
autocmd BufNewFile,BufReadPost *.md set filetype=markdown
let g:markdown_fenced_languages = ['html', 'python', 'bash=sh']

"python
au FileType python setlocal colorcolumn=80
au FileType python setlocal expandtab

"linux code looks really ugly without 8-sized tabs
autocmd BufRead /usr/src/linux* call WhitespaceTab(8)


" -----------------
" Bindings
" -----------------
" use w!! to save files with sudo
cmap w!! w !sudo tee > /dev/null %

" :diffw for current diff
cmap diffw exec 'w !git diff --no-index -- - ' . shellescape(expand('%'))

" diff refresh on write
autocmd BufWritePost * if &diff == 1 | diffupdate | endif

" refresh vimrc after saving
autocmd BufWritePost ~/.vimrc source %

" autosave delay, cursorhold trigger, default: 4000ms
setl updatetime=400









