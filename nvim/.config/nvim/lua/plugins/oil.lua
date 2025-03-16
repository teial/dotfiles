return {
    "stevearc/oil.nvim",
    cmd = "Oil",
    keys = {
        {
            "<leader>fo",
            function()
                require("oil").open()
            end,
            desc = "Oil",
        },
    },
    opts = {
        default_file_explorer = true,
        view_options = {
            show_hidden = true,
        },
    },
}
