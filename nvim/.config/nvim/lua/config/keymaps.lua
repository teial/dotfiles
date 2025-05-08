-- Map Ctrl-G to ESC to emulate Emacs.
vim.keymap.set({ "n", "v", "i" }, "<C-g>", "<Esc>", { noremap = false })

-- Map B and E to ^ and $ because they are easier to type, and I don't use them
-- for their intended reason anyway.
vim.keymap.set("n", "E", "$", { noremap = false })
vim.keymap.set("n", "B", "^", { noremap = false })

-- Map jj in insert mode to Esc.
vim.keymap.set("i", "jj", "<Esc>")
