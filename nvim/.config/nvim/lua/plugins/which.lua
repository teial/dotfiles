return {
    {
        "folke/which-key.nvim",
        opts = {
            delay = function(ctx)
                return 0
            end,
            spec = {
                {
                    mode = { "n", "v" },
                    { "<leader>o", group = "obsidian", icon = { icon = "💎" } },
                    { "<leader>ol", group = "links" },
                    { "<leader>oj", group = "journal" },
                    { "<leader>on", group = "note" },
                    { "<leader>gc", group = "conflicts" },
                },
            },
        },
    },
}
