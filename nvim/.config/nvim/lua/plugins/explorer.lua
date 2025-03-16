return {
    "folke/snacks.nvim",
    opts = {
        explorer = {
            replace_netrw = true,
        },
        picker = {
            sources = {
                explorer = {
                    layout = {
                        layout = {
                            box = "vertical",
                            position = "left",
                            width = 0.2,
                            {
                                win = "input",
                                max_height = 1,
                                height = 1,
                                border = { "", "", "", " ", "", "", "", " " },
                            },
                            {
                                win = "list",
                                border = "top",
                            },
                        },
                    },
                    win = {
                        input = {
                            keys = {
                                ["<Esc>"] = "toggle_focus",
                            },
                        },
                        list = {
                            keys = {
                                ["<space>"] = "confirm",
                                ["<Esc>"] = "",
                            },
                        },
                    },
                },
            },
        },
    },
}
