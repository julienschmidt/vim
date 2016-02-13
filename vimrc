" -----------------
" General
" -----------------
set nocp                           "enable Vi incompatible features
filetype plugin on                 "per-filetype settings
filetype indent on                 "per-filetype indentation


" -----------------
" Plugins
" -----------------
execute pathogen#infect()


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
set t_Co=256
set background=dark

" load railscasts theme
colorscheme railscasts

highlight SpecialKey ctermfg=darkgreen
highlight SpecialKey guifg=#808080

syntax on                          "syntax highlighting
set nu                             "show line numbers
set ru                             "show ruler at cursor pos
set cursorline                     "highlight current line
set hlsearch                       "highlight search results
set showmatch                      "matching parentheses
set gcr=n:blinkon0                 "turn off blinking cursor in normal mode

" highlight the word under cursor (CursorMoved is inperformant)
highlight WordUnderCursor cterm=underline "ctermfg=7
autocmd CursorHold * exe printf('match WordUnderCursor /\V\<%s\>/', escape(expand('<cword>'), '/\'))

"statusbar
set laststatus=2
let g:airline_theme = 'bubblegum'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1

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
set mousehide                      "Hide the mouse cursor while typing
set virtualedit=onemore            "Allow for cursor beyond last character
set sc                             "show incomplete commmands
set tw=72                          "textwidth 72 characters

autocmd GUIEnter * set visualbell t_vb=

if has('clipboard')
    if has('unnamedplus')          "use + register for copy-paste when available
        set clipboard=unnamed,unnamedplus
    else                           "otherwise try to  use * register
        set clipboard=unnamed
    endif
endif

if has('macunix')
    let g:tagbar_ctags_bin='/usr/local/bin/ctags'  "proper Ctags locations
endif

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

" strip whitespace
function! StripTrailingWhitespace()
    " save last search and cursor position
    let _s=@/
    let l = line(".")
    let c = col(".")
    " strip
    %s/\s\+$//e
    " restore previous search history and cursor position
    let @/=_s
    call cursor(l, c)
endfunction


" -----------------
" Code
" -----------------
"go
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_interfaces = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
let g:go_fmt_command = "goimports"
let g:syntastic_go_checkers = ['golint', 'govet', 'errcheck']
let g:syntastic_mode_map = { 'mode': 'active', 'passive_filetypes': ['go'] }
au FileType go nmap <Leader>s <Plug>(go-implements)
au FileType go nmap <Leader>i <Plug>(go-info)
au FileType go nmap <Leader>e <Plug>(go-rename)
au FileType go nmap <leader>r <Plug>(go-run)
au FileType go nmap <leader>b <Plug>(go-build)
au FileType go nmap <leader>t <Plug>(go-test)
au FileType go nmap <Leader>gd <Plug>(go-doc)
au FileType go nmap <Leader>gv <Plug>(go-doc-vertical)
au FileType go nmap <leader>co <Plug>(go-coverage)

"Markdown
autocmd BufNewFile,BufReadPost *.md set filetype=markdown
let g:markdown_fenced_languages = ['html', 'python', 'bash=sh']

"python
au FileType python setlocal colorcolumn=80
au FileType python setlocal expandtab

"linux code looks really ugly without 8-sized tabs
autocmd BufRead /usr/src/linux* call WhitespaceTab(8)

"always start in first line in git commit messages
au FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])

"refresh vimrc after saving
autocmd BufWritePost ~/.vimrc source %
autocmd BufWritePost ~/.vim/vimrc source %

"strip whitespace
autocmd FileType c,cpp,java,go,php,javascript,puppet,python,rust,twig,xml,yml,perl,sql autocmd BufWritePre <buffer> call StripTrailingWhitespace()

" -----------------
" Bindings
" -----------------
" toogle Tagbar
nmap <F8> :TagbarToggle<CR>

" toggle pastemode
nnoremap <F12> :set invnumber number?<CR>:set invpaste paste?<CR>
set pastetoggle=<F12>

" use w!! to save files with sudo
cmap w!! w !sudo tee > /dev/null %

" :diffw for current diff
cmap diffw exec 'w !git diff --no-index -- - ' . shellescape(expand('%'))

" diff refresh on write
autocmd BufWritePost * if &diff == 1 | diffupdate | endif

" autosave delay, cursorhold trigger, default: 4000ms
setl updatetime=400

