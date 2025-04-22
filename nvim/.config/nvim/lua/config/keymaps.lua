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

vim.keymap.set("n", "<leader>tp", function()
    vim.cmd("edit ~/Forge/teial/2-projects/index.md")
end, { desc = "Projects" })

vim.keymap.set("n", "<leader>ta", function()
    vim.cmd("edit ~/Forge/teial/7-archive/index.md")
end, { desc = "Archive" })

vim.keymap.set("n", "<leader>te", function()
    vim.cmd("edit ~/Forge/teial/0-system/exploration.md")
end, { desc = "Exploration" })
