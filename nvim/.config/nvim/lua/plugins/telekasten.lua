return {
    'renerocksai/telekasten.nvim',
    dependencies = {'nvim-telescope/telescope.nvim'},
    config = function()
        local home = vim.fn.expand("~/Drive")
        local system = home .. '/' .. '0-system'
        require('telekasten').setup({
            home = home,
            take_over_my_home = true,
            dailies      = system .. '/' .. 'daily',
            weeklies     = system .. '/' .. 'weekly',
            templates    = system .. '/' .. 'templates',
            image_subdir = nil,
            follow_creates_nonexisting = true,
            dailies_create_nonexisting = true,
            weeklies_create_nonexisting = true,
            template_new_note = nil,
            template_new_daily = nil,
            template_new_daily = nil,
        })
        -- Launch panel if nothing is typed after <leader>z
        vim.keymap.set("n", "<leader>n", "<cmd>Telekasten panel<CR>")

        -- Most used functions
        vim.keymap.set("n", "<leader>nf", "<cmd>Telekasten find_notes<CR>")
        vim.keymap.set("n", "<leader>ng", "<cmd>Telekasten search_notes<CR>")
        vim.keymap.set("n", "<leader>nd", "<cmd>Telekasten goto_today<CR>")
        vim.keymap.set("n", "<leader>nw", "<cmd>Telekasten goto_thisweek<CR>")
        vim.keymap.set("n", "<leader>na", "<cmd>Telekasten follow_link<CR>")
        vim.keymap.set("n", "<leader>ne", "<cmd>Telekasten new_note<CR>")
        vim.keymap.set("n", "<leader>nr", "<cmd>Telekasten rename_note<CR>")
        vim.keymap.set("n", "<leader>ny", "<cmd>Telekasten yank_notelink<CR>")
        vim.keymap.set("n", "<leader>nb", "<cmd>Telekasten show_backlinks<CR>")
        vim.keymap.set("n", "<leader>nt", "<cmd>Telekasten toggle_todo<CR>")
        vim.keymap.set("n", "<leader>ns", "<cmd>Telekasten show_tags<CR>")

        -- Call insert link automatically when we start typing a link
        vim.keymap.set("i", "[[", "<cmd>Telekasten insert_link<CR>")
    end
}
