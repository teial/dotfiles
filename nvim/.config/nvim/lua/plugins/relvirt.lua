return {
    dir = vim.fn.stdpath("config") .. "/lua/plugins/relvirt",
    name = "relvirt",
    lazy = false,
    opts = {
        ignored_filetypes = { "NvimTree", "lazy", "TelescopePrompt", "help", "snacks.*" },
    },
    keys = {
        { "<leader>,", function() require("relvirt").toggle() end, desc = "Toggle virtual relative numbers" },
    },
}
