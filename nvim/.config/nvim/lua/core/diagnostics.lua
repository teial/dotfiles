-- Diagnostis keymaps
vim.keymap.set("n", "<leader>ee", vim.diagnostic.open_float, { desc = "errors" })
vim.keymap.set("n", "<leader>e[", vim.diagnostic.goto_prev, { desc = "prev" })
vim.keymap.set("n", "<leader>e]", vim.diagnostic.goto_next, { desc = "next" })
vim.keymap.set("n", "<space>eq", vim.diagnostic.setloclist, { desc = "locations" })

-- Show border
vim.diagnostic.config({
    float = { border = 'single' },
})
