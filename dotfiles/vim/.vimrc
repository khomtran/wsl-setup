" ------------------------------------------------------------------------------
" PLUGIN MANAGER (VIM-PLUG)
" ------------------------------------------------------------------------------

call plug#begin('~/.vim/plugged')

" Appearance
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" File navigation
Plug 'preservim/nerdtree'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Git integration
Plug 'tpope/vim-fugitive'

" Editing enhancements
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'

call plug#end()

" ------------------------------------------------------------------------------
" VIM SETTINGS
" ------------------------------------------------------------------------------

" Set line numbers
set number


" NERDTree configuration
nmap <C-n> :NERDTreeToggle<CR>

" FZF configuration
nmap <C-p> :FZF<CR>
