" vim:foldmethod=marker

" Windows Runtime ---------------------------------{{{
" On Windows, also use '.vim' instead of 'vimfiles'; this makes synchronization
" across (heterogeneous) systems easier.
" if has('win32') || has('win64')
"     let $PATH .= ';' . 'c:\Python33;c:\Python33\scripts'
"     set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after
"     set renderoptions=type:directx,gamma:1.0,contrast:0.9,level:1.0,geom:1,renmode:5,taamode:1
"
"     "
"     " Make UltiSnips edit snippets file in the correct directory.
"     "
"     let g:UltiSnipsSnippetsDir="~/.vim/UltiSnips"
"
" endif
" }}}

" Setting up NeoBundle --------------------------------------------------{{{
if has('vim_starting')
	set nocompatible
	set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

call neobundle#begin(expand('~/.vim/bundle/'))
" }}}

" Plugins ----------------------------------------------------------------{{{
NeoBundleFetch 'Shougo/neobundle.vim'

" Better status bar
" NeoBundle 'bling/vim-airline'

" extended % matching for HTML, LaTeX, and many more languages
NeoBundle 'vim-scripts/matchit.zip'


" Colorschemes
NeoBundle 'nielsmadan/harlequin'
NeoBundle 'morhetz/gruvbox'
NeoBundle 'ajh17/Spacegray.vim'

" File navigation
NeoBundle 'ctrlpvim/ctrlp.vim'
NeoBundle 'tpope/vim-vinegar'

" Surround text
NeoBundle 'tpope/vim-surround.git'

" Change font size with +/- keys
NeoBundle 'thinca/vim-fontzoom.git'

" Commenting/uncommenting code
NeoBundle 'tomtom/tcomment_vim.git'

" Git integration
NeoBundle 'tpope/vim-fugitive.git'
NeoBundle 'int3/vim-extradite.git'

" LESS Syntax highlighting, indent, and autocompletion
NeoBundle 'groenewege/vim-less.git'

" Misc functions needed by other plugins
NeoBundle 'xolox/vim-misc.git'

" Search using ag.
NeoBundle 'rking/ag.vim'

" Syntax check for several languages
NeoBundle 'scrooloose/syntastic.git'

NeoBundle 'SirVer/ultisnips'

"
" Make it possible to execute programs within vim (requires compilation)
"
execute "NeoBundle 'Shougo/vimproc.vim'," . string({
      \ 'directory': 'vimproc',
      \ 'build' : {
      \     'windows' : 'call "%ProgramFiles(x86)%\Microsoft Visual Studio 10.0\VC\vcvarsall.bat" amd64 && nmake -f make_msvc.mak',
      \     'cygwin' : 'make -f make_cygwin.mak',
      \     'mac' : 'make -f make_mac.mak',
      \     'unix' : 'make -f make_unix.mak',
      \    },
      \ })


"
" Python
"

" Better indentation for Python
NeoBundle 'hynek/vim-python-pep8-indent.git'

" Python matchit support
NeoBundle 'voithos/vim-python-matchit'

" Highlighting for restructured text
NeoBundle 'Rykka/riv.vim'

" Python aoutocompletion with JEDI
" NeoBundle 'davidhalter/jedi-vim'

"
" JavaScript
"
NeoBundleLazy 'pangloss/vim-javascript'
au FileType javascript NeoBundleSource vim-javascript


call neobundle#end()

filetype plugin indent on

NeoBundleCheck
" }}}

" Leaders {{{
let mapleader=" "
let maplocalleader="\\"
" }}}

" Key Mappings {{{

" Quick escape
inoremap jk <esc>

" run make silently and go to first error
nnoremap <leader>m :silent make\|redraw!\|cc<CR>

nnoremap <leader>p :CtrlP<cr>

" Mapping to save all files
nnoremap <silent> <leader>w :wa<cr>:echo 'saved...'<cr>

" Clear higlighting of words matching search
nnoremap <silent> <leader><space> :noh<cr>:call clearmatches()<cr>

" Rebuild ctags
:nnoremap <silent> <F12> :echo "Rebuilding tags..."<cr>:VimProcBang ctags -R .<cr>:echo "Rebuilt tags"<cr>

" Shortcut to edit .vimrc
nnoremap <leader>ev :e $MYVIMRC<cr>

" Set current directory to currently open file.
nnoremap <leader>cd :lcd %:p:h<cr>

" Ack
nnoremap <leader>a :Ag ""<left>
let g:ag_mapping_message=0

" JSON Formatting
nnoremap <leader>js :%!python -m json.tool<cr>

" Browse directory of file in current buffer
nnoremap <leader>ex :Explore<cr>

" Take over Fontzoom's default mappings
let g:fontzoom_no_default_key_mappings=1
nnoremap <leader>= :Fontzoom +1<cr>
nnoremap <leader>- :Fontzoom -1<cr>

" }}}

" VimWiki with dropbox as storage {{{

if has('win32') || has('win64')
    let dropbox_path = $HOME . "/Dropbox"
else
    let dropbox_path = "~/Dropbox"
endif


let g:vimwiki_list = [{'path': dropbox_path . '/vimwiki/main/src', 'path_html': dropbox_path . '/vimwiki/main/html'}]
" }}}

" Options {{{
syntax on " Turn on syntax highlighting

set smartindent
set autoindent
set expandtab
set tabstop=4
set shiftwidth=4
set number
set laststatus=2
set autowrite           " Automatically save buffer
set number
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
" Hide texts line '--INSERT--' as we're using powerline
"
set noshowmode

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

"
" I'm almost always using vim with git anyway...
"
let g:ctrlp_use_caching = 0
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -oc --exclude-standard']
" let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']
let g:ctrlp_working_path_mode = ''

"
" Syntastic options
"
let g:syntastic_enable_signs = 1
let g:syntastic_error_symbol = "☣"
let g:syntastic_warning_symbol = "☠"
let g:syntastic_style_error_symbol = "💩"
let g:syntastic_style_warning_symbol = "✗"
let g:syntastic_always_populate_loc_list = 1

" }}}

" Python Settings {{{
let g:syntastic_python_python_exec = '/usr/bin/python3'
let g:syntastic_python_checkers = ['python', 'flake8', 'pep8', 'pyflakes']

augroup filetype_python
    autocmd!
    autocmd FileType python setlocal colorcolumn=80
    " Prevent JEDI from showing docstrings automatically on autocomplete
    autocmd FileType python setlocal completeopt-=preview

    " We don't need smartindent in python. Makes comments always go to 
    " the start of the line.
    autocmd FileType python setlocal nosmartindent
augroup END


" {{{ Functions for running unit tests in python
function! RunAllTests()
    silent ! echo -e "\033[1;36mRunning all unit tests\033[0m"
    set makeprg=nosetests\ --with-describe-it\ --with-terseout
    " set errorformat=%f:%l:\ %m,%C>\ %.%#
    exec "make!"
endfunction

function! RunFlake()
    set makeprg=python\ setup.py\ flake8
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

nnoremap <leader>a :call RunAllTests()<cr>:redraw<cr>:call JumpToError()<cr>
nnoremap <leader>f :call RunFlake()<cr>:redraw<cr>:call JumpToError()<cr>

" }}}

" }}}

" Appearance {{{

colorscheme gruvbox
set background=dark

set list                " Display special characters (e.g. trailing whitespace)
set listchars=tab:▷◆,trail:◆

"
" Only display trailing whitespaces when we're not in insert mode
"
augroup trailing
    au!
    au InsertEnter * :set listchars-=trail:◆
    au InsertLeave * :set listchars+=trail:◆
augroup END

" let g:airline_powerline_fonts = 1

if has('gui_running')
    set guioptions=-Mc

    if has('win32') || has('win64')
        set guifont=Source_Code_Pro_Medium:h10:cANSI
    elseif has('macunix')
        set guifont=Source\ Code\ Pro\ Medium:h16
    endif

else
    "
    " Make vim display colors and fonts properly in terminal windows (conemu)
    "
    if has("win32unix")
        set term=xterm-256color
        set t_ut=
    else
        set termencoding=ut8
        set term=xterm
        set t_Co=256
        let &t_AB="\e[48;5;%dm"
        let &t_AF="\e[38;5;%dm"
        let &t_ZH="\e[3m"
    endif
endif

set cursorline
if &background == 'light'
    highlight CursorLine cterm=NONE ctermbg=LightGray ctermfg=NONE
else
    highlight CursorLine cterm=NONE ctermbg=233 ctermfg=NONE
    highlight colorcolumn ctermbg=235
endif

" }}}

"{{{ Powerline
python3 from powerline.vim import setup as powerline_setup
python3 powerline_setup()
python3 del powerline_setup
"}}}
