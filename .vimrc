set ls=2         " allways show status line
set ruler        " show the cursor position all the time

" tabs are 4 spaces
set shiftwidth=4
set tabstop=4
set softtabstop=4
set expandtab
" Allow backspacing over autoident, joining lines and over start of insert
set backspace=start,indent,eol 

" syntax highlighting and smart indent
syntax on
set autoindent      " always set autoindenting on
set smartindent     " smart indent
set cindent         " cindent
filetype plugin indent on " Turns on filetype detection, filetype plugins, and
                          " filetype indenting all of which add nice extra 
                          " features to whatever language you're using

syntax enable " Turns on filetype detection if not already on, and 
              " then applies filetype-specific highlighting. 

if has("autocmd")
    " Restore cursor position
    autocmd BufReadPost * if line("'\"") > 0|if line("'\"") <= line("$")|exe("norm '\"")|else|exe "norm $"|endif|endif

    " NerdTREE shortcut
    autocmd VimEnter * if exists(":NERDTreeToggle") | exe "map <F2> :NERDTreeToggle<CR>" | endif
endi

" display the current mode and partially-typed commands in the status line:
set showmode
set showcmd

" shortcuts
map <Tab> <C-W><C-W>

" Folding
map f za
hi Folded ctermbg=0

" Tabs
map <C-t> <Esc>:tabnew<CR>
map <C-l> :tabnext<CR>
map <C-h> :tabprevious<CR>

colorscheme igor

