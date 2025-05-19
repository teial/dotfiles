-- Map B and E to ^ and $ because they are easier to type, and I don't use them
-- for their intended reason anyway.
vim.keymap.set("n", "E", "$", { noremap = false })
vim.keymap.set("n", "B", "^", { noremap = false })

-- Map jj and jk in insert mode to Esc.
vim.keymap.set("i", "jj", "<Esc>")
vim.keymap.set("i", "jk", "<Esc>")
