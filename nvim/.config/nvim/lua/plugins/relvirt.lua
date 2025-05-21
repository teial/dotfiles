return {
    dir = vim.fn.stdpath("config") .. "/lua/plugins/relvirt",
    name = "relvirt",
    lazy = false, -- or true if you want to load it on demand
    config = function() require("relvirt").setup() end,
    keys = {
        { "<leader>,", function() require("relvirt").toggle() end, desc = "Toggle virtual relative numbers" },
    },
}
