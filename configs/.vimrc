set encoding=utf-8

language messages zh_TW.utf-8

syntax on

set autoindent
set smartindent
set number
set ruler
set cursorline
set wrap
set mouse=a
set hlsearch
set incsearch

set history=100
set backspace=2
set shiftwidth=4
set tabstop=4
set expandtab

set t_Co=256
colorscheme default

set foldmethod=indent
set foldlevel=0
set foldnestmax=2

" use alt to switch tab
:map <¡> 1gt
:map <™> 2gt
:map <£> 3gt
:map <¢> 4gt
:map <∞> 5gt
:map <§> 6gt
:map <¶> 7gt
:map <•> 8gt
:map <ª> 9gt
:map <º> :tablast<CR>
:map <≥> gt
:map <≤> gT
:map <˜> :Tex<CR>
