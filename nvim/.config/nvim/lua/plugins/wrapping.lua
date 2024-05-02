return {
    "andrewferrier/wrapping.nvim",
    config = function()
        local wrapping = require("wrapping")
        wrapping.setup({
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
        vim.keymap.set("n", "<leader>tw", wrapping.toggle_wrap_mode, { desc = "wrap mode" })
    end,
}
