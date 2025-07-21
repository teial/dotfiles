return {
    "teial/relvirt.nvim",
    name = "relvirt",
    lazy = false,
    opts = {
        ignored_filetypes = { "lazy", "minifiles", "TelescopePrompt", "mason", "help", "snacks.*" },
    },
    keys = {
        { "<leader>uR", function() require("relvirt").toggle() end, desc = "Toggle virtual relative numbers" },
    },
}
