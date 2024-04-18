return {
    "epwalsh/obsidian.nvim",
    version = "*",
    lazy = true,
    ft = "markdown",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    config = function()
        local obsidian = require("obsidian")
        obsidian.setup({
            workspaces = {
                {
                    name = "Drive",
                    path = "~/Drive",
                },
            },
        })
        vim.keymap.set("n", "<leader>nt", obsidian.util.toggle_checkbox, { desc = "toggle checkbox" })
    end,
}
