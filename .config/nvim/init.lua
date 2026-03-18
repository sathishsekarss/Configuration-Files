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
