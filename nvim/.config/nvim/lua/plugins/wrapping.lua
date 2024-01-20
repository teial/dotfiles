return {
    'andrewferrier/wrapping.nvim',
    config = function()
        require('wrapping').setup({
            create_commands = false,
            create_keymaps = false,
            auto_set_mode_filetype_allowlist = {
                "asciidoc",
                "gitcommit",
                "latex",
                "mail",
                "markdown",
                "rst",
                "tex",
                "text",
                "telekasten",
            },
            softener = {
                telekasten = nil,
                markdown = nil,
            },
        })
        vim.keymap.set("n", "j", "gj", {})
        vim.keymap.set("n", "k", "gk", {})
    end
}

