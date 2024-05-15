return {
    "nvim-treesitter/nvim-treesitter",
    config = function()
        require("nvim-treesitter.configs").setup({
            ensure_installed = {
                "c",
                "cpp",
                "lua",
                "vim",
                "vimdoc",
                "query",
                "rust",
                "go",
                "gomod",
                "gosum",
                "gitignore",
                "markdown",
                "markdown_inline",
                "java",
                "haskell",
                "elixir",
                "dockerfile",
                "zig",
                "asm",
            },
            highlight = { enable = true },
            indent = { enable = true },
            additional_vim_regex_highlighting = false,
        })
    end,
}
