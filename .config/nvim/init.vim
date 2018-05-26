" vim:foldmethod=marker


" {{{ Plugins
call plug#begin()

" Plug 'bling/vim-airline'
" let g:airline_powerline_fonts=1
" let g:airline_detect_spell=0
Plug 'itchyny/lightline.vim'
let g:lightline = {
    \ 'colorscheme': 'wombat',
    \ 'component': {
    \  'readonly': '%{&readonly?"":""}',
    \ },
    \ 'active': {
    \   'left': [ [ 'mode', 'paste' ],
    \             [ 'readonly', 'relativepath', 'modified' ] ]
    \ },
    \ 'inactive': {
    \    'left': [ [ 'relativepath' ] ]
    \ },
    \ 'separator': { 'left': '', 'right': '' },
    \ 'subseparator': { 'left': '', 'right': '' }
    \ }

" Mirror vim status bar theme to tmux
Plug 'edkolev/tmuxline.vim'

Plug 'christoomey/vim-tmux-navigator'

" extended % matching for HTML, LaTeX, and many more languages
Plug 'vim-scripts/matchit.zip'

Plug 'easymotion/vim-easymotion'

" Colorschemes
Plug 'NLKNguyen/papercolor-theme'
Plug 'joshdick/onedark.vim'
Plug 'altercation/vim-colors-solarized'
Plug 'jdkanani/vim-material-theme'
Plug 'morhetz/gruvbox'
Plug 'chriskempson/base16-vim'
Plug 'lifepillar/vim-solarized8'
Plug 'romainl/flattened'

"{{{ ctrlp: File navigation
" Plug 'ctrlpvim/ctrlp.vim'

Plug 'junegunn/fzf', {'dir': '~/.fzf', 'do': './install --all'}
Plug 'junegunn/fzf.vim'
"
" I'm almost always using vim with git anyway...
"
" let g:ctrlp_use_caching = 0
" let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -oc --exclude-standard']
" let g:ctrlp_working_path_mode = ''
"}}}

Plug 'tpope/vim-vinegar'

" Surround text
Plug 'tpope/vim-surround'

" Commenting/uncommenting code
Plug 'tomtom/tcomment_vim'

" Git integration
Plug 'tpope/vim-fugitive'
Plug 'int3/vim-extradite'

" LESS Syntax highlighting, indent, and autocompletion
Plug 'groenewege/vim-less', { 'for': 'less' }


" Highlight yanked area
Plug 'machakann/vim-highlightedyank'
if !exists('##TextYankPost')
    map y <Plug>(highlightedyank)
endif

"{{{ syntastic: Syntax check for several languages
" Plug 'scrooloose/syntastic', { 'for': 'python' }
" let g:syntastic_always_populate_loc_list = 1
"
" let g:syntastic_python_python_exec = '/usr/bin/python3'
" let g:syntastic_python_checkers = ['python', 'flake8']
"}}}

"{{{ Ale
Plug 'w0rp/ale'
let g:ale_lint_on_save = 1
let g:ale_lint_on_text_changed = 0
let g:ale_lint_on_enter = 1
let g:ale_lint_on_insert_leave = 0
let g:ale_lint_delay = 200
let g:ale_open_list = 1
let g:ale_set_signs = 1
let g:ale_sign_column_always = 0
"}}}


Plug 'Konfekt/FastFold'
let g:fastfold_fold_command_suffixes =
            \['x','X','a','A','o','O','c','C','r','R','m','M','i','n','N']

" vim org mode {{{
Plug 'jceb/vim-orgmode', { 'for': 'org' }
Plug 'tpope/vim-speeddating', { 'for': 'org' }
command! Notes execute "e ~/Dropbox/notes"
command! -nargs=1 NewNote execute "e ~/Dropbox/notes/<args>.org"
" }}}

"
" Python
"

" Better indentation for Python
Plug 'hynek/vim-python-pep8-indent', { 'for': 'python' }

" Python matchit support
Plug 'voithos/vim-python-matchit', { 'for': 'python' }

function! GetDirectories(path)
    let dircontent = globpath(a:path, '*', 0, 1)
    call filter(dircontent, 'isdirectory(v:val)')
    return dircontent
endfunction

let g:deoplete#sources#jedi#extra_path = GetDirectories('/home/joakim/src')
let g:deoplete#enable_at_startup = 1
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'zchee/deoplete-jedi'

" Highlighting for restructured text
Plug 'Rykka/riv.vim', { 'for': 'rst' }

Plug 'hdima/python-syntax', { 'for': 'python' }

Plug 'SirVer/ultisnips'

Plug 'GutenYe/json5.vim'

"
" JavaScript
"
Plug 'pangloss/vim-javascript', { 'for': 'javascript' }

" Vim as a tool for writing
Plug 'reedes/vim-pencil'
Plug 'junegunn/goyo.vim'

" C64 development
Plug 'gryf/kickass-syntax-vim', { 'for': 'kickass' }
autocmd BufRead *.asm set filetype=kickass

" Breaking the habit of using Vim ineffectively
Plug 'takac/vim-hardtime'
let g:hardtime_default_on = 1  " Have hardtime be on by default for all buffers
let g:hardtime_maxcount = 5  " Allow 5 repetitions
let g:hardtime_allow_different_key = 1 " Allow jjjjjkkk

call plug#end()

filetype plugin indent on

" }}}

" Leaders {{{
let mapleader=" "
let maplocalleader="\\"
" }}}

" Key Mappings {{{

" Quick escape
inoremap jk <esc>

" nnoremap <leader>p :CtrlP<cr>
" nnoremap <leader>t :CtrlPTag<cr>
" nnoremap <leader>b :CtrlPBuffer<cr>

nnoremap <leader>p :Files<cr>
nnoremap <leader>t :Tags<cr>
nnoremap <leader>b :Buffers<cr>
nnoremap <leader>a :Ag 

" Clear higlighting of words matching search
nnoremap <silent> <leader>cl :noh<cr>:call clearmatches()<cr>

" Rebuild ctags
:nnoremap <silent> <F12> :silent !ctags .<cr>

" Shortcut to edit .vimrc
nnoremap <leader>ev :e $MYVIMRC<cr>

" JSON Formatting
nnoremap <leader>js :%!python -m json.tool<cr>

" Browse directory of file in current buffer
nnoremap <leader>ex :Explore<cr>

" Search with ag
" nnoremap <leader>a :Ag ""<left>

" Switch between dark and light background
nnoremap  <leader>B :<c-u>exe "colors" (g:colors_name =~# "dark"
    \ ? substitute(g:colors_name, 'dark', 'light', '')
    \ : substitute(g:colors_name, 'light', 'dark', '')
    \ )<cr>

" Less awkward windows handling
nnoremap <leader>ws <C-w><C-s>
nnoremap <leader>wv <C-w><C-v>
nnoremap <C-h> <C-w><C-h>
nnoremap <C-j> <C-w><C-j>
nnoremap <C-k> <C-w><C-k>
nnoremap <C-l> <C-w><C-l>

" Poor mans clipboard on terminal linux
vnoremap <leader>y :w! /tmp/vimclipboardbuf<CR>
nnoremap <leader>v :r! cat /tmp/vimclipboardbuf<CR>
" }}}


" Options {{{
syntax on " Turn on syntax highlighting

set smartindent
set autoindent
set expandtab
set tabstop=4
set shiftwidth=4
set laststatus=2
set autowrite           " Automatically save buffer
set incsearch
set scrolloff=3         " keep 3 lines when scrolling
set showcmd             " display incomplete commands
set nobackup            " do not keep a backup file
set nowritebackup
set noswapfile
set hlsearch            " highlight searches
set showmatch           " jump to matches when entering regexp
set ignorecase          " ignore case when searching
set smartcase           " no ignorecase if Uppercase char present
set encoding=utf-8

"
" Show relative line numbers, except for on the current line
"
set relativenumber
set number

"
" Easiear copy paste to system clipboard
"
set clipboard=unnamed


"
" Turn off error beeps and flashing
"
set noerrorbells visualbell t_vb=
autocmd GUIEnter * set visualbell t_vb=

set backspace=indent,eol,start  " make that backspace key work the way it should

"
" Patterns to ignore for ctrlp etc.
"
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*.so,*.o,*.pyc
set wildignore+=*/node_modules/*,*/bower_components/*,*/venv/*,*/Python34/*

"
" If compiler error refers to a file already open in a window,
" use that window instead of opening the file in the last active
" window.
"
set switchbuf=useopen



" }}}

" Python Settings {{{

augroup filetype_python
    autocmd!
    autocmd FileType python setlocal colorcolumn=80
    " autocmd FileType python setlocal omnifunc=python3complete#Complete

    " We don't need smartindent in python. Makes comments always go to 
    " the start of the line.
    autocmd FileType python setlocal nosmartindent

    " Show whitespace markers for python files so we detect tabs or
    " trailing whitespaces
    autocmd FileType python setlocal list
    autocmd FileType python setlocal listchars=tab:▷◆,trail:◆

    " Prevent Jedi from showing docstrings
    autocmd FileType python setlocal completeopt-=preview
augroup END


" {{{ Functions for running tests in python
function! RunTests(args)
    set makeprg=nosetests\ --with-terseout
    exec "make! " . a:args
endfunction

function! RunFlake()
    set makeprg=flake8
    exec "make!"
endfunction

function! JumpToError()
    if getqflist() != []
        for error in getqflist()
            if error['valid']
                break
            endif
        endfor
        let error_message = substitute(error['text'], '^ *', '', 'g')
        silent cc!
        if error['bufnr'] != 0
            exec ":sbuffer " . error['bufnr']
        endif
        call RedBar()
        echo error_message
    else
        call GreenBar()
        echo "All tests passed"
    endif
endfunction

function! RedBar()
    hi RedBar ctermfg=white ctermbg=red guibg=red
    echohl RedBar
    echon repeat(" ",&columns - 1)
    echohl None
endfunction

function! GreenBar()
    hi GreenBar ctermfg=white ctermbg=green guibg=green
    echohl GreenBar
    echon repeat(" ",&columns - 1)
    echohl None
endfunction"

nnoremap <leader>ra :wa<cr>:call RunTests("")<cr>:redraw<cr>:call JumpToError()<cr>
nnoremap <leader>rf :wa<cr>:call RunFlake()<cr>:redraw<cr>:call JumpToError()<cr>

" }}}

nnoremap <leader>rd :redraw!<cr>
" }}}

" Appearance {{{

"
" Only display trailing whitespaces when we're not in insert mode
"
augroup trailing
    au!
    au InsertEnter * :set listchars-=trail:◆
    au InsertLeave * :set listchars+=trail:◆
augroup END

set termencoding=ut8

" Clearing uses the current background color
set t_ut=

" Enable true colors
set termguicolors


" Italics mode
let &t_ZH="\e[3m"
let &t_AB="\e[48;5;%dm"


" Set forground color
let &t_AF="\e[38;5;%dm"

" Set foreground/background color RGB
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

set cursorline

highlight! link MatchParen StatusLine

colorscheme base16-gruvbox-dark-hard

" }}}
