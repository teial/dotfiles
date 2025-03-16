return {
    "akinsho/git-conflict.nvim",
    version = "*",
    config = function()
        vim.keymap.set("n", "<leader>gco", "<cmd>GitConflictChooseOurs<cr>")
        vim.keymap.set("n", "<leader>gct", "<cmd>GitConflictChooseTheirs<cr>")
        vim.keymap.set("n", "<leader>gcb", "<cmd>GitConflictChooseBoth<cr>")
        vim.keymap.set("n", "<leader>gcn", "<cmd>GitConflictChooseNone<cr>")
        vim.keymap.set("n", "]x", "<cmd>GitConflictNextConflict<cr>")
        vim.keymap.set("n", "[x", "<cmd>GitConflictPrevConflict<cr>")
        require("git-conflict").setup({
            default_mappings = false,
        })
    end,
}
