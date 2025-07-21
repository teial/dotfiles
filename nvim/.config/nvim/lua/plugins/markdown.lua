return {
    {
        "MeanderingProgrammer/render-markdown.nvim",
        ft = { "markdown", "Avante" },
        opts = {
            file_types = { "markdown", "Avante" },
            indent = { enabled = false },
            sign = { enabled = true },
            heading = {
                backgrounds = {},
            },
            latex = { enable = false },
            code = {
                width = "block",
                border = "thin",
                min_width = 80,
                left_pad = 2,
                right_pad = 4,
                language_pad = 2,
                highlight = "CursorLine",
                below = "",
            },
        },
    },
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        ft = { "markdown" },
        build = function() vim.fn["mkdp#util#install"]() end,
    },
}
