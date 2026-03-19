local opts = { noremap = true, silent = true }

vim.keymap.set("i", "jk", "<Esc>", opts)

vim.keymap.set("n", "cw", "ciw", opts)
vim.keymap.set("n", "dw", "diw", opts)
vim.keymap.set("n", "vw", "viw", opts)

vim.keymap.set("n", "cu", "viwu", opts)
vim.keymap.set("n", "cU", "viwU", opts)

vim.keymap.set("n", 'c"', 'ci"', opts)
vim.keymap.set("n", 'd"', 'di"', opts)

vim.keymap.set("n", "<C-h>", "<C-w>h", { noremap = true })
vim.keymap.set("n", "<C-j>", "<C-w>j", { noremap = true })
vim.keymap.set("n", "<C-k>", "<C-w>k", { noremap = true })
vim.keymap.set("n", "<C-l>", "<C-w>l", { noremap = true })

vim.keymap.set("n", "<leader>n", ":NERDTreeToggle<CR>", { noremap = true, silent = true })

vim.cmd([[
call plug#begin()

Plug 'tpope/vim-sensible'
Plug 'preservim/nerdtree'
Plug 'vim-airline/vim-airline'
Plug 'easymotion/vim-easymotion'
Plug 'sphamba/smear-cursor.nvim'
Plug 'iamcco/markdown-preview.nvim'
Plug 'karb94/neoscroll.nvim'

call plug#end()
]])

require("smear_cursor").setup({
    enabled = true,
})

-- START: Enabling copy past from system clipboard
vim.opt.clipboard = "unnamedplus"
vim.keymap.set('!', '<C-v>', '<C-r>+')
-- END: Enabling copy past from system clipboard
--
vim.cmd([[aunmenu PopUp]])

--This configuration is for alloing all the color options to airline plugin
vim.opt.termguicolors = true

-- START: for mapping new scroll default key maps
require('neoscroll').setup({ mappings = {'<C-u>', '<C-d>', '<C-b>', '<C-f>'} })
-- END: for mapping new scroll default key maps

vim.api.nvim_create_autocmd("VimEnter", {
callback = function()
      vim.cmd("NERDTree")
	  vim.cmd("wincmd p")
	    end
    })
