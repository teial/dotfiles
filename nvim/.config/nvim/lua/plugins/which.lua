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
                    { "<leader>t", group = "gtd", icon = { icon = "📆" } },
                    { "<leader>gc", group = "conflicts" },
                },
            },
        },
    },
}
