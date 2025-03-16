return {
    "folke/snacks.nvim",
    opts = {
        explorer = {
            replace_netrw = true,
        },
        picker = {
            config = function()
                Snacks.util.set_hl({
                    Border = { fg = "#51597d" },
                }, { prefix = "Custom", default = true })
            end,
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
                                wo = {
                                    winhighlight = "FloatBorder:CustomBorder",
                                },
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
