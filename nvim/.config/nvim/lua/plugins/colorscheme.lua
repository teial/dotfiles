return {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
        require("catppuccin").setup({
            flavour = "macchiato",
            transparent_background = true,
            treesitter = true,
            integrations = {
                notify = true,
                neotree = true,
                which_key = true,
            },
        })
        require("catppuccin").load()
    end,
}
