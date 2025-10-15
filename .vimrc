set nocompatible              " be iMproved, required
filetype off

" Vundle
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'ipartola/igor-vim'
Plugin 'bronson/vim-trailing-whitespace'
Plugin 'tmhedberg/SimpylFold'
Plugin 'konfekt/FastFold'

call vundle#end()
colorscheme igor

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
set termguicolors
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

" Don't highlight search results
set nohlsearch

" shortcuts
map <Tab> <C-W><C-W>

fun! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun
:noremap <Leader>w :call TrimWhitespace()<CR>

" Folding - use f to fold/unfold blocks
map f za
let g:python_fold_comments = 0
let g:python_fold_docstrings = 0
set foldnestmax=2

" Tabs
map <C-t> <Esc>:tabnew<CR>
map <C-l> :tabnext<CR>
map <C-h> :tabprevious<CR>

" Backup files
set backupdir=~/.vim/,.,/tmp
set directory=~/.vim/,.,/tmp

"let g:ale_set_highlights = 1
"let g:ale_sign_column_always = 1
"let g:ale_linters = {
"\   'python': ['python', 'pyflakes'],
"\}

"let g:ale_lint_on_text_changed = 'always'
"let g:ale_set_signs = 0


let g:fastfold_savehook = 1
let g:fastfold_fold_command_suffixes = []
let g:fastfold_force = 1


" Transparent editing of gpg encrypted files.
augroup encrypted
au!
" First make sure nothing is written to ~/.viminfo while editing
" an encrypted file.
autocmd BufReadPre,FileReadPre      *.gpg set viminfo=
" We don't want a swap file, as it writes unencrypted data to disk
autocmd BufReadPre,FileReadPre      *.gpg set noswapfile
" Switch to binary mode to read the encrypted file
autocmd BufReadPre,FileReadPre      *.gpg set bin
autocmd BufReadPre,FileReadPre      *.gpg let ch_save = &ch|set ch=2
autocmd BufReadPre,FileReadPre      *.gpg let shsave=&sh
autocmd BufReadPre,FileReadPre      *.gpg let &sh='sh'
autocmd BufReadPre,FileReadPre      *.gpg let ch_save = &ch|set ch=2
autocmd BufReadPost,FileReadPost    *.gpg '[,']!gpg --decrypt --default-recipient-self 2> /dev/null
autocmd BufReadPost,FileReadPost    *.gpg let &sh=shsave
" Switch to normal mode for editing
autocmd BufReadPost,FileReadPost    *.gpg set nobin
autocmd BufReadPost,FileReadPost    *.gpg let &ch = ch_save|unlet ch_save
autocmd BufReadPost,FileReadPost    *.gpg execute ":doautocmd BufReadPost " . expand("%:r")
" Convert all text to encrypted text before writing
autocmd BufWritePre,FileWritePre    *.gpg set bin
autocmd BufWritePre,FileWritePre    *.gpg let shsave=&sh
autocmd BufWritePre,FileWritePre    *.gpg let &sh='sh'
autocmd BufWritePre,FileWritePre    *.gpg '[,']!gpg --armor --encrypt --default-recipient-self 2>/dev/null
autocmd BufWritePre,FileWritePre    *.gpg let &sh=shsave
" Undo the encryption so we are back in the normal text, directly
" after the file has been written.
autocmd BufWritePost,FileWritePost  *.gpg silent u
autocmd BufWritePost,FileWritePost  *.gpg set nobin

