" Basic

    " set clipboard=unnamedplus " Copy to clipboard
    set mouse=a
    set ttimeoutlen=50
    set foldlevel=99
    set noswapfile
    set encoding=UTF-8
    set fileencoding=utf-8
    set history=2000
    set ffs=mac,unix
    set fileformat=unix
    set noendofline binary
    set laststatus=2
    set nowrap
    set noreadonly
    set hidden
    set ignorecase
    set whichwrap+=<,>,h,l
    set smartcase
    set lazyredraw   " Don't redraw while executing macros (good performance config)
    set noerrorbells " No annoying sound on errors
    set novisualbell
    set timeoutlen=500
    set nobackup
    set expandtab " Use spaces instead of tabs
    set shiftwidth=2 " 1 tab == 2 spaces
    set tabstop=2
    set smartindent
    set nocursorcolumn
    set nocursorline
    set hlsearch " Highlight search results
    set conceallevel=3

" TUI

    " set number
    set relativenumber
    set numberwidth=4
    set showtabline=0
    set so=8
    set showmatch " Show matching brackets when text indicator is over them

" Colors

    let base16colorspace=256
    syntax sync minlines=256

    hi htmlArg cterm=italic
    hi Comment cterm=italic
    hi Type    cterm=italic
    highlight Comment cterm=italic gui=italic

    hi Function cterm=bold
    filetype indent plugin on

    set foldmethod=indent