return {
    'nvim-treesitter/nvim-treesitter',
    config = function()
        require('nvim-treesitter.configs').setup({
            ensure_installed = {
                "c",
                "lua",
                "vim",
                "vimdoc",
                "query",
                "rust",
                "go",
            },
            highlight = { enable = true },
            indent = { enable = true },
            additional_vim_regex_highlighting = false,
        })
    end
}
