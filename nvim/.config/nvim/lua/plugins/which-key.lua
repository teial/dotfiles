return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
        vim.o.timeout = true
        vim.o.timeoutlen = 100
        local which = require("which-key")
        which.setup({
            window = {
                border = "single",
            },
        })
        which.register({ ["<leader>n"] = { desc = "notes" } })
        which.register({ ["<leader>t"] = { desc = "tree" } })
        which.register({ ["<leader>f"] = { desc = "files" } })
        which.register({ ["<leader>c"] = { desc = "code" } })
    end,
    opts = {},
}
