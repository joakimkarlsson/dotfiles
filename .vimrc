
" On Windows, also use '.vim' instead of 'vimfiles'; this makes synchronization
" across (heterogeneous) systems easier.
if has('win32') || has('win64')
  let $PATH .= ';' . 'c:\Python27;c:\Python27\scripts'
  set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after
endif

if has('vim_starting')
	set nocompatible
	set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

call neobundle#begin(expand('~/.vim/bundle/'))

NeoBundleFetch 'Shougo/neobundle.vim'

" Better status bar
NeoBundle 'blueyed/vim-airline.git'

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

NeoBundle 'mileszs/ack.vim'

" Syntax check for several languages
NeoBundle 'scrooloose/syntastic.git'

if has('python')
    NeoBundle 'SirVer/ultisnips'
endif

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


"
" JavaScript
"
NeoBundle 'pangloss/vim-javascript'
NeoBundleLazy 'jelera/vim-javascript-syntax', {'autoload':{'filetypes':['javascript']}}


call neobundle#end()

filetype plugin indent on

NeoBundleCheck


"
" Set appearance if we're running gvim
"

if has('gui_running')
  colorscheme harlequin
  set vb t_vb=
  set guifont=Source_Code_Pro_Medium:h10:cANSI

  set cursorline
  highlight CursorLine cterm=NONE ctermbg=235 ctermfg=NONE
endif

"
" KEYBINDINGS
"

map <leader>p :CtrlPCurWD<cr>
map <leader>t :CtrlPTag<cr>
map <leader>n :NERDTreeToggle<cr>
map <leader>r :NERDTreeFind<cr>

syntax on " Turn on syntax highlighting

set smartindent
set autoindent
set expandtab
set tabstop=4
set shiftwidth=4
set guioptions-=T
set number
set laststatus=2
set autowrite
set number
set incsearch

let &colorcolumn=80
highlight colorcolumn ctermbg=235


set scrolloff=3         " keep 3 lines when scrolling
set showcmd             " display incomplete commands
set nobackup            " do not keep a backup file
set nowritebackup
set noswapfile
set hlsearch            " no highlight searches
set showmatch           " jump to matches when entering regexp
set ignorecase          " ignore case when searching
set smartcase           " no ignorecase if Uppercase char present
set visualbell t_vb=    " turn off error beep/flash
set novisualbell        " turn off visual bell
set encoding=utf-8

set backspace=indent,eol,start  " make that backspace key work the way it should

"
" Patterns to ignore for ctrlp etc.
"
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*.so,*.o

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
" Python Settings
"
let g:syntastic_python_checkers = ['python', 'flake8', 'pep8', 'pyflakes']

au FileType python set omnifunc=pythoncomplete#Complete
au FileType python set tabstop=4
au FileType python set softtabstop=4
au FileType python set shiftwidth=4
au FileType python set smarttab
au FileType python set expandtab
