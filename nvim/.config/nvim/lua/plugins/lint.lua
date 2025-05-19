return {
    {
        "mfussenegger/nvim-lint",
        enabled = false,
        opts = {
            linters = {
                ["markdownlint-cli2"] = {
                    args = { "--config", ".markdownlint-cli2.yaml", "--" },
                },
            },
        },
    },
}
