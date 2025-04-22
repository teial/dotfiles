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

-- Enable autoread and set up checking triggers.
vim.o.autoread = true
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
    command = "if mode() != 'c' | checktime | endif",
    pattern = "*",
})
vim.api.nvim_create_autocmd({ "FileChangedShellPost" }, {
    pattern = "*",
    command = "echohl WarningMsg | echo 'File changed on disk. Buffer reloaded.' | echohl None",
})
