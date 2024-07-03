return {
    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local actions = require("telescope.actions")
            require("telescope").setup({
                defaults = {
                    mappings = {
                        i = {
                            ["<C-k>"] = actions.move_selection_previous,
                            ["<C-j>"] = actions.move_selection_next,
                        },
                    },
                    borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
                    extensions = {
                        frecency = {
                            db_validate_threshold = 50,
                            ignore_patterns = { "*.git/*", "*/tmp/*" },
                        },
                    },
                },
            })
            local builtin = require("telescope.builtin")
            vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "find" })
            vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "grep" })
            vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "buffers" })
            vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "tags" })
        end,
    },
    {
        "nvim-telescope/telescope-ui-select.nvim",
        config = function()
            require("telescope").setup({
                extensions = {
                    ["ui-select"] = {
                        require("telescope.themes").get_dropdown({}),
                    },
                },
            })
            require("telescope").load_extension("ui-select")
        end,
    },
    {
        "nvim-telescope/telescope-frecency.nvim",
        config = function()
            require("telescope").load_extension("frecency")
            vim.keymap.set("n", "<leader>fr", "<Cmd>Telescope frecency<CR>", { desc = "recent" })
        end,
    },
    {
        'ghassan0/telescope-glyph.nvim',
        config = function()
            require('telescope').load_extension('glyph')
            vim.keymap.set("n", "<leader>fl", "<cmd>Telescope glyph<CR>", { desc = "glyphs" })
        end
    },
}
