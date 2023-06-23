#call plug#begin()
#Plug 'preservim/nerdtree'
#Plug 'tpope/vim-surround'
#Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
#Plug 'junegunn/fzf.vim'
#Plug 'airblade/vim-gitgutter'
#Plug 'tpope/vim-commentary'
#Plug 'Xuyuanp/nerdtree-git-plugin'
#Plug 'ryanoasis/vim-devicons'
#Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
#Plug 'vim-airline/vim-airline'
#Plug 'w0rp/ale'
#Plug 'valloric/youcompleteme'
#call plug#end()
#
#" Start NERDTree. If a file is specified, move the cursor to its window.
#autocmd StdinReadPre * let s:std_in=1
#autocmd VimEnter * NERDTree | if argc() > 0 || exists("s:std_in") | wincmd p | endif
#
#" Close the tab if NERDTree is the only window remaining in it.
#autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif