set nocompatible              " be iMproved, required
filetype off                  " required

call plug#begin()

Plug 'scrooloose/nerdtree'
Plug 'scrooloose/syntastic'
Plug 'fatih/vim-go'
Plug 'pangloss/vim-javascript'
Plug 'leafgarland/typescript-vim'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'altercation/vim-colors-solarized'

call plug#end()

filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set backspace=indent,eol,start
set number relativenumber
set clipboard=unnamed
set tabstop=4
set shiftwidth=4
set noswapfile

syntax on
set background=dark
colorscheme solarized

"" syntastic configuration

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

let g:syntastic_typescript_checkers = ['eslint']

"" vim-rooter configuration

let g:rooter_change_directory_for_non_project_files = ''

"" ctrl-p configuration

let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']

"" TypeScript filetype recognition

autocmd BufNewFile,BufRead *.ts setlocal filetype=typescript

autocmd FileType yaml setlocal shiftwidth=2 tabstop=2
