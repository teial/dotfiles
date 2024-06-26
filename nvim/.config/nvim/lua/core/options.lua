local opt = vim.opt -- for conciseness

-- line numbers
opt.relativenumber = true -- show relative line numbers
opt.number = true         -- shows absolute line number on cursor line (when relative number is on)

-- tabs & indentation
opt.tabstop = 4       -- 4 spaces for tabs
vim.o.softtabstop = 4 -- 4 spaces for soft tabs
opt.shiftwidth = 4    -- 4 spaces for indent width
opt.expandtab = true  -- expand tab to spaces
opt.autoindent = true -- copy indent from current line when starting new one
opt.breakindent = true

-- search settings
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true  -- if you include mixed case in your search, assumes you want case-sensitive
opt.hlsearch = false  -- don't highlight the results of the previous search

-- cursor line
opt.cursorline = true -- highlight the current cursor line

-- appearance
opt.termguicolors = true -- turn on termguicolors
opt.background = "dark"  -- colorschemes that can be light or dark will be made dark
opt.signcolumn = "yes"   -- show sign column so that text doesn't shift
opt.conceallevel = 2     -- hide text with conceal attributes

-- backspace
opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position

-- clipboard
opt.clipboard:append("unnamedplus") -- use system clipboard as default register

-- split windows
opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the bottom

-- swap
opt.swapfile = false -- turn off swapfile

-- Editor
opt.listchars = {
    tab = "│─",
    lead = "·",
    trail = "·",
    eol = "↵",
}
