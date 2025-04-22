vim.api.nvim_create_autocmd("User", {
    pattern = "MiniFilesBufferCreate",
    callback = function(ev)
        vim.schedule(function()
            vim.api.nvim_set_option_value("buftype", "acwrite", { buf = 0 })
            vim.api.nvim_buf_set_name(0, tostring(vim.api.nvim_get_current_win()))
            vim.api.nvim_create_autocmd("BufWriteCmd", {
                buffer = ev.data.buf_id,
                callback = function()
                    require("mini.files").synchronize()
                end,
            })
        end)
    end,
})

return {
    "echasnovski/mini.files",
    keys = {
        {
            "<leader>fm",
            function()
                require("mini.files").open(LazyVim.root(), true)
            end,
            desc = "Open mini.files (root)",
        },
        {
            "<leader>fM",
            function()
                require("mini.files").open(vim.uv.cwd(), true)
            end,
            desc = "Open mini.files (cwd)",
        },
    },
}
