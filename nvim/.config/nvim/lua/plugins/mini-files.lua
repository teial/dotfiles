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
