return {
    {
        "mfussenegger/nvim-lint",
        enabled = true,
        opts = {
            linters = {
                ["markdownlint-cli2"] = {
                    args = { "--config", ".markdownlint-cli2.yaml", "--" },
                },
            },
        },
    },
}
