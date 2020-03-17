if !has('win32')
    let g:ruby_host_prog = 'rvm 2.7.0@nvim do neovim-ruby-host'
endif

call plug#begin('~/.local/share/nvim/plugged')
    Plug 'flazz/vim-colorschemes'
    Plug 'skielbasa/vim-material-monokai'

    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'

    Plug 'ap/vim-css-color'
    Plug 'powerman/vim-plugin-AnsiEsc'

    Plug 'scrooloose/nerdtree'

    Plug 'OrangeT/vim-csharp'
    Plug 'neovimhaskell/haskell-vim'
    Plug 'udalov/kotlin-vim'
    Plug 'rodjek/vim-puppet'
    if !has('win32')
        Plug 'lnl7/vim-nix'
    endif
call plug#end()

"set guicursor=
set termguicolors

"set background=dark
let g:enable_bold_font = 1
let g:enable_italic_font = 1
let g:airline_powerline_fonts = 1

colorscheme PaperColor
"let g:airline_theme = 'evening'

let g:NERDTreeWinSize = 60

set splitright

set number
set colorcolumn=81

set shiftwidth=4 expandtab smarttab
autocmd filetype ruby,yaml,html,xml set shiftwidth=2
autocmd bufnewfile,bufread Jenkinsfile set filetype=groovy
autocmd bufnewfile,bufread Dockerfile.* set filetype=dockerfile
autocmd bufnewfile,bufread * syntax sync fromstart

let g:haskell_indent_disable = 1

set mouse=a
