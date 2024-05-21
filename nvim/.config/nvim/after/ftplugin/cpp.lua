local cppman = require("cppman")

local open_cppman_for = function()
    cppman.open_cppman_for(vim.fn.expand("<cword>"))
end

local cppman = function()
    cppman.input()
end

vim.keymap.set("n", "<localleader>w", open_cppman_for, { desc = "cpp word search" })
vim.keymap.set("n", "<localleader>s", cppman, { desc = "cpp search" })
