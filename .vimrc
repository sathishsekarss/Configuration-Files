"* this remaps the Esc key to jj.
inoremap jk <Esc>

"this code is used to connect the plugins to the applications
call plug#begin()
  "Nerdtree
  Plug 'joshdick/onedark.vim'
  Plug 'preservim/nerdtree'
  "Gruvbox
  Plug 'morhetz/gruvbox'
  "Vim-Pdf reader
  Plug 'makerj/vim-pdf'

  "Source from Github.
  "Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'scrooloose/nerdtree'
  "Plug 'tsony-tsonev/nerdtree-git-plugin'
  Plug 'Xuyuanp/nerdtree-git-plugin'
  Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
  Plug 'ryanoasis/vim-devicons'
  Plug 'airblade/vim-gitgutter'
  Plug 'ctrlpvim/ctrlp.vim' " fuzzy find files
  Plug 'scrooloose/nerdcommenter'
  Plug 'dense-analysis/ale'
  Plug 'tpope/vim-surround'
  Plug 'Matt-A-Bennett/vim-surround-funk'
  Plug 'easymotion/vim-easymotion'
call plug#end()

colorscheme gruvbox

"this line map's the Control n to NERDTree command
map <C-n> :NERDTree

"open's vim with NERDTree opened
autocmd VimEnter * NERDTree

"this line makes sure that syntax highlight is on.
syntax on


"These remaps are to reduce the object key mapping like ciw, diw and viw, etc.
nnoremap cw ciw
nnoremap dw diw
nnoremap vw viw
nnoremap c" ci"
nnoremap d" di"

"sets the line number
set number

"Not in use
"nnoremap <c-o> :action Back<cr>

"nnoremap <c-i> :action Forward<cr>

"set's autoindent on
set autoindent

"this is code helps us to see the changes that are made after editing a file.
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
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l


"Cursor for Normal and Insert mode
"let &t_SI = \e[6 q
"let &t_EI = \e[2 q

"Capital J disabled - can be reused if wanted
"map <S-j> <Nop>
"nnoremap <S-j> <Nop>

"this configuration is very important for vimrc, without the cursor will break
"in vim. ( but for neo vim it's different ) ( link:
"https://vi.stackexchange.com/questions/9131/i-cant-switch-to-cursor-in-insert-mode
")
let &t_SI = "\<esc>[5 q"
let &t_SR = "\<esc>[5 q"
let &t_EI = "\<esc>[2 q"


set background=dark
colorscheme onedark

imap <C-BS> <C-W>
nnoremap H gT
nnoremap L gt

"set encoding=utf8
autocmd InsertEnter * set cursorline
autocmd InsertLeave * set nocursorline