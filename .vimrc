" vim:foldmethod=marker

" Windows Runtime ---------------------------------{{{
" On Windows, also use '.vim' instead of 'vimfiles'; this makes synchronization
" across (heterogeneous) systems easier.
if has('win32') || has('win64')
    let $PATH .= ';' . 'c:\Python33;c:\Python33\scripts'
    set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after
    set renderoptions=type:directx,gamma:1.0,contrast:0.9,level:1.0,geom:1,renmode:5,taamode:1

    "
    " Make UltiSnips edit snippets file in the correct directory.
    "
    let g:UltiSnipsSnippetsDir="~/.vim/UltiSnips"

endif
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
NeoBundle 'itchyny/lightline.vim'

" extended % matching for HTML, LaTeX, and many more languages
NeoBundle 'vim-scripts/matchit.zip'


" Dark, high contrast color scheme
NeoBundle 'nielsmadan/harlequin'

" File navigation
NeoBundle 'kien/ctrlp.vim.git'
NeoBundle 'Shougo/unite.vim.git'
NeoBundle 'blueyed/nerdtree.git'

" Add support for local vimrc files (.lvimrc)
NeoBundle 'embear/vim-localvimrc.git'

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

" Improved integration between Vim and its environment (fullscreen, open URL, background command execution)
NeoBundle 'xolox/vim-shell'

NeoBundle 'mileszs/ack.vim'

" Syntax check for several languages
NeoBundle 'scrooloose/syntastic.git'

if has('python')
    NeoBundle 'SirVer/ultisnips'
endif

" Personal Wiki for Vim
NeoBundle 'vimwiki/vimwiki'

" 
" Make it possible to execute programs within vim (requires compilation)
"
let vimproc_updcmd = has('win64') ?
      \ 'tools\\update-dll-mingw 64' : 'tools\\update-dll-mingw 32'
execute "NeoBundle 'Shougo/vimproc.vim'," . string({
      \ 'directory': 'vimproc',
      \ 'build' : {
      \     'windows' : vimproc_updcmd,
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

"
" JavaScript
"
NeoBundleLazy 'pangloss/vim-javascript'
au FileType javascript NeoBundleSource vim-javascript

call neobundle#end()

filetype plugin indent on

NeoBundleCheck
" }}}

" GUI appearances {{{


if has('gui_running')
    set guioptions=-M

    colorscheme harlequin

    if has('win32') || has('win64')
        set guifont=Source_Code_Pro_Medium:h11:cANSI
    elseif has('macunix')
        set guifont=Source\ Code\ Pro\ Medium:h16
    endif

    set cursorline
    highlight CursorLine cterm=NONE ctermbg=235 ctermfg=NONE
else
    set term=xterm
    set t_Co=256
    let &t_AB="\e[48;5;%dm"
    let &t_AF="\e[38;5;%dm"
    colorscheme harlequin
endif
" }}}

" Leaders {{{
let mapleader=","
let maplocalleader="\\"
highlight colorcolumn ctermbg=235
" }}}

" Key Mappings {{{
nnoremap <leader>p :CtrlPCurWD<cr>
nnoremap <leader>t :CtrlPTag<cr>
nnoremap <leader>n :NERDTreeToggle<cr>
nnoremap <leader>r :NERDTreeFind<cr>

" Clear higlighting of words matching search
nnoremap <silent> <leader><space> :noh<cr>:call clearmatches()<cr>

" Rebuild ctags
:nnoremap <silent> <F12> :echo "Rebuilding tags..."<cr>:VimProcBang ctags -R .<cr>:echo "Rebuilt tags"<cr>

" Shortcut to edit .vimrc
nnoremap <leader>ev :e $MYVIMRC<cr>

" Ack
nnoremap <leader>a :Ack 
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

set list                " Display special characters (e.g. trailing whitespace)
set listchars=tab:▷◆,trail:◆

augroup trailing
    au!
    au InsertEnter * :set listchars-=trail:◆
    au InsertLeave * :set listchars+=trail:◆
augroup END

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
let NERDTreeIgnore = ['\.pyc$']

"
" Automatically load local vimrc files
"
let g:localvimrc_ask = 0

"
" If compiler error refers to a file already open in a window,
" use that window instead of opening the file in the last active
" window.
"
set switchbuf=useopen

"
" Use unicode characters to make NERDTree look prettier
"
let g:NERDTreeDirArrows=1


" }}}

" Python Settings {{{
let g:syntastic_python_checkers = ['python', 'flake8', 'pep8', 'pyflakes']

augroup filetype_python
    autocmd!
    autocmd FileType python setlocal colorcolumn=80
augroup END
" }}}
