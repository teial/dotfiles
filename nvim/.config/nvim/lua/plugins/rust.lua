return {
    {
        "mrcjkb/rustaceanvim",
        ft = "rust",
        version = "^4",
        config = function()
            vim.g.rustaceanvim = {
                server = {
                    settings = {
                        ["rust-analyzer"] = {
                            cargo = {
                                allFeatures = true,
                            },
                            checkOnSave = {
                                allFeatures = true,
                                command = "clippy",
                            },
                            inlayHints = {
                                parameterHints = { enable = false },
                                maxLength = 15,
                            },
                            rustfmt = {
                                extraArgs = { "--config", "max_width=120" },
                            },
                        },
                    },
                },
            }
        end,
    },
    {
        "saecki/crates.nvim",
        tag = "stable",
        config = function()
            require("crates").setup()
        end,
    },
}
