"this code is used to connect the plugins to the applications
call plug#begin()
  "NERDTree
  Plug 'preservim/nerdtree'
  "Gruvbox
  Plug 'morhetz/gruvbox'
  "Vim-Pdf reader
  Plug 'makerj/vim-pdf'

  "Source from Github.
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'scrooloose/nerdtree'
  "Plug 'tsony-tsonev/nerdtree-git-plugin'
  Plug 'Xuyuanp/nerdtree-git-plugin'
  Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
  Plug 'ryanoasis/vim-devicons'
  Plug 'airblade/vim-gitgutter'
  Plug 'ctrlpvim/ctrlp.vim' " fuzzy find files
  Plug 'scrooloose/nerdcommenter'
call plug#end()

colorscheme gruvbox

"this line map's the Control n to NERDTree command
map <C-n> :NERDTree

"open's vim with NERDTree opened
autocmd VimEnter * NERDTree

"this line makes sure that syntax highlight is on.
syntax on

"* this remaps the Esc key to jj.
inoremap jj <Esc>

"sets the line number
set number

"Not in use
"nnoremap <c-o> :action Back<cr>

"nnoremap <c-i> :action Forward<cr>

"set's autoindent on
set autoindent

"this is code, which helps us to see the changes that are made after editing a file.
function! s:DiffWithSaved()
  let filetype=&ft
    diffthis
      vnew | r # | normal! 1Gdd
        diffthis
	  exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
	  endfunction
	  com! DiffSaved call s:DiffWithSaved()

"remapping h,j,k,l to Control w to navigate between windows
	  
inoremap <silent><expr> <c-space> coc#refresh()

"this piece of code is responsible for the background color code
let g:gruvbox_contrast_dark = "soft"
set t_Co=256
set background=dark
colorscheme gruvbox
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
