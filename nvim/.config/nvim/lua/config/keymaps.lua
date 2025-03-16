-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "<leader>ti", function()
    vim.cmd("edit ~/Forge/teial/0-system/inbox.md")
end, { desc = "Inbox" })

vim.keymap.set("n", "<leader>tt", function()
    vim.cmd("edit ~/Forge/teial/0-system/tasks.md")
end, { desc = "Tasks" })

vim.keymap.set("n", "<leader>ts", function()
    vim.cmd("edit ~/Forge/teial/0-system/scratch.md")
end, { desc = "Scratchpad" })
