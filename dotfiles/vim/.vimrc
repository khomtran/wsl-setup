" ------------------------------------------------------------------------------
" PLUGIN MANAGER (VIM-PLUG)
" ------------------------------------------------------------------------------

call plug#begin('~/.vim/plugged')

" Appearance
Plug 'gruvbox-community/gruvbox'
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

" Set colorscheme
try
  colorscheme gruvbox
catch /^Vim\%(.*):E185:/
  " Colorscheme not found, do nothing
endtry

" Set airline theme
let g:airline_theme='gruvbox'

" NERDTree configuration
nmap <C-n> :NERDTreeToggle<CR>

" FZF configuration
nmap <C-p> :FZF<CR>
