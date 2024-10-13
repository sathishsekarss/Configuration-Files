"**SETTING'S RELATED TO KEYBINDINGS**
inoremap jk <Esc>
"These remaps are to reduce the object key mapping like ciw, diw and viw, etc.
nnoremap cw ciw
nnoremap dw diw
nnoremap vw viw
nnoremap c" ci"
nnoremap d" di"

"helps in jumping between open split windows
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

"help's in jumping between tabs
nnoremap H gT
nnoremap L gt

"use unkown
inoremap <C-BS> <C-w>

"sets the line number
set number

"Not in use
"nnoremap <c-o> :action Back<cr>

"nnoremap <c-i> :action Forward<cr>

"set's autoindent on
set autoindent
"**END OF CONFIGURATIONS**

"**SETTINGS RELATED TO PLUGIN'S USED**
"this code is used to connect the plugins to the applications
call plug#begin()
  "Nerdtree
  Plug 'joshdick/onedark.vim'
  Plug 'preservim/nerdtree'
  Plug 'junegunn/fzf'
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
  Plug 'dense-analysis/ale'
  Plug 'tpope/vim-surround'
  Plug 'Matt-A-Bennett/vim-surround-funk'
  Plug 'easymotion/vim-easymotion'
call plug#end()
"**END OF CONFIGURATIONS**

"list of other plugins to use for development
"other than this run :CocInstall coc-html to add html language suggestions

"**SETTING'S RELATED TO NERDTREE SETUP**
"this line map's the Control n to NERDTree command
map <C-n> :NERDTree
"open's vim with NERDTree opened
autocmd VimEnter * NERDTree

"this line makes sure that syntax highlight is on.
syntax on
"**END OF CONFIGURATIONS**




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

"this piece of code is responsible for the background color code

"currently not using this
"Cursor for Normal and Insert mode
"let &t_SI = \e[6 q"
"let &t_EI = \e[2 q"

"Capital J disabled - can be reused if wanted
"map <S-j> <Nop>
"nnoremap <S-j> <Nop>

"**SETTINGS RELATED TO IDE COLOR CONFIGURATIONS**
colorscheme gruvbox
set background=dark
colorscheme onedark
"**END OF CONFIGURATIONS**


"ignore file search for node module in ctrlp plugin for linux environmnt
set wildignore+=*/tmp/*,*/node_modules/*',*.so,*.swp,*.zip
let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'

set encoding=utf8
