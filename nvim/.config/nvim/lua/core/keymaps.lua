-- Set up leaders
vim.g.mapleader = ","
vim.g.maplocalleader = ";"

-- Move between windows
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-l>", "<C-w>l")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")

-- Split widows
vim.keymap.set("n", "<C-s>h", ":split<CR><C-w>")
vim.keymap.set("n", "<C-s>v", ":vsplit<CR><C-w>")
