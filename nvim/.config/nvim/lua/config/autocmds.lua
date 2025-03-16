-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Open explorer automatically when opening neomvim.
vim.api.nvim_create_autocmd("VimEnter", {
    pattern = "*",
    callback = function()
        Snacks.explorer()
    end,
    group = vim.api.nvim_create_augroup("auto_open_neotree", { clear = true }),
    desc = "Auto open Neo-tree when entering buffer",
})

-- Remember folds.
local persistent_folds = vim.api.nvim_create_augroup("Persistent folds", { clear = true })
vim.api.nvim_create_autocmd({ "BufWinLeave", "BufWritePost", "WinLeave" }, {
    desc = "Save view with mkview for real files",
    group = persistent_folds,
    callback = function(args)
        if vim.b[args.buf].view_activated then
            vim.cmd.mkview({ mods = { emsg_silent = true } })
        end
    end,
})
vim.api.nvim_create_autocmd("BufWinEnter", {
    desc = "Try to load file view if available and enable view saving for real files",
    group = persistent_folds,
    callback = function(args)
        if not vim.b[args.buf].view_activated then
            local filetype = vim.api.nvim_get_option_value("filetype", { buf = args.buf })
            local buftype = vim.api.nvim_get_option_value("buftype", { buf = args.buf })
            local ignore_filetypes = { "gitcommit", "gitrebase", "svg", "hgcommit" }
            if buftype == "" and filetype and filetype ~= "" and not vim.tbl_contains(ignore_filetypes, filetype) then
                vim.b[args.buf].view_activated = true
                vim.cmd.loadview({ mods = { emsg_silent = true } })
            end
        end
    end,
})

-- Enable autoread and set up checking triggers
vim.o.autoread = true
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
    command = "if mode() != 'c' | checktime | endif",
    pattern = "*",
})
vim.api.nvim_create_autocmd({ "FileChangedShellPost" }, {
    pattern = "*",
    command = "echohl WarningMsg | echo 'File changed on disk. Buffer reloaded.' | echohl None",
})
