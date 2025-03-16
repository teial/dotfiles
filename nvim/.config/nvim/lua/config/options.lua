-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Set up indenting.
vim.o.tabstop = 4 -- A TAB character looks like 4 spaces
vim.o.expandtab = true -- Pressing the TAB key will insert spaces instead of a TAB character
vim.o.softtabstop = 4 -- Number of spaces inserted instead of a TAB character
vim.o.shiftwidth = 4 -- Number of spaces inserted when indenting
vim.o.breakindent = true -- Indentation in long lines in list items etc.

-- Remap leader and localleader.
vim.g.mapleader = ","
vim.g.maplocalleader = ";"

-- Default line wrapping and width.
vim.opt_local.wrap = false
vim.opt_local.textwidth = 120

-- Update appearance.
vim.opt.termguicolors = true -- turn on termguicolors
vim.opt.background = "dark" -- colorschemes that can be light or dark will be made dark
vim.opt.signcolumn = "yes" -- show sign column so that text doesn't shift
vim.opt_local.conceallevel = 2 -- hide text with conceal attributes

-- Visual goodies.
vim.opt.cursorlineopt = "number,screenline"
