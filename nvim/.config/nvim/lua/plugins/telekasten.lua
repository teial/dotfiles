return {
    "renerocksai/telekasten.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
        local home = vim.fn.expand("~/Drive")
        local system = home .. "/" .. "0-system"
        local templates = system .. "/" .. "templates"
        require("telekasten").setup({
            home = home,
            take_over_my_home = true,
            dailies = system .. "/" .. "daily",
            weeklies = system .. "/" .. "weekly",
            templates = system .. "/" .. "templates",
            image_subdir = nil,
            follow_creates_nonexisting = true,
            dailies_create_nonexisting = true,
            weeklies_create_nonexisting = true,
            template_new_note = templates .. "/" .. "note.md",
            template_new_daily = nil,
            template_new_weekly = nil,
        })
        vim.keymap.set("n", "<leader>nf", "<cmd>Telekasten find_notes<CR>", { desc = "find" })
        vim.keymap.set("n", "<leader>ng", "<cmd>Telekasten search_notes<CR>", { desc = "grep" })
        vim.keymap.set("n", "<leader>nd", "<cmd>Telekasten goto_today<CR>", { desc = "today" })
        vim.keymap.set("n", "<leader>nw", "<cmd>Telekasten goto_thisweek<CR>", { desc = "this week" })
        vim.keymap.set("n", "<leader>nz", "<cmd>Telekasten follow_link<CR>", { desc = "follow" })
        vim.keymap.set("n", "<leader>nn", "<cmd>Telekasten new_note<CR>", { desc = "new note" })
        vim.keymap.set("n", "<leader>nr", "<cmd>Telekasten rename_note<CR>", { desc = "rename note" })
        vim.keymap.set("n", "<leader>ny", "<cmd>Telekasten yank_notelink<CR>", { desc = "yank link" })
        vim.keymap.set("n", "<leader>nb", "<cmd>Telekasten show_backlinks<CR>", { desc = "backlinks" })
        vim.keymap.set("n", "<leader>nt", "<cmd>Telekasten toggle_todo<CR>", { desc = "toggle todo" })
        vim.keymap.set("n", "<leader>ns", "<cmd>Telekasten show_tags<CR>", { desc = "tags" })
        vim.keymap.set("i", "[[", "<cmd>Telekasten insert_link<CR>")
    end,
}
