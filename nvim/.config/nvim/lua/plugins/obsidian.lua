return {
    "obsidian-nvim/obsidian.nvim",
    version = "*",
    lazy = true,
    ft = "markdown",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    keys = {
        {
            "<leader>oc",
            function()
                return require("obsidian").util.toggle_checkbox()
            end,
            desc = "toggle checkbox",
        },
        { "<leader>od", "<cmd>ObsidianToday<CR>", desc = "today" },
        { "<leader>oy", "<cmd>ObsidianToday -1<CR>", desc = "yesterday" },
        { "<leader>om", "<cmd>ObsidianToday 1<CR>", desc = "tomorrow" },
        { "<leader>on", "<cmd>ObsidianNew<CR>", desc = "new note" },
        { "<leader>op", "<cmd>Obsidian new_from_template<CR>", desc = "new from template" },
        { "<leader>ob", "<cmd>ObsidianBacklinks<CR>", desc = "backlinks" },
        { "<leader>os", "<cmd>ObsidianSearch<CR>", desc = "search" },
        { "<leader>ot", "<cmd>ObsidianTags<CR>", desc = "tags" },
        { "<leader>oq", "<cmd>ObsidianQuickSwitch<CR>", desc = "quick switch" },
        { "<leader>oq", "<cmd>ObsidianWorkspace<CR>", desc = "workspace" },
        { "<leader>oll", "<cmd>Obsidian link<CR>", desc = "link", mode = { "n", "v" } },
        { "<leader>oln", "<cmd>Obsidian link_new<CR>", desc = "link new", mode = { "n", "v" } },
    },
    opts = {
        completion = {
            nvim_cmp = true,
            min_chars = 2,
        },
        ui = {
            -- use markdown.nvim instead for these
            bullets = {},
            external_link_icon = {},
            checkboxes = {},
        },
        workspaces = {
            {
                name = "teial",
                path = "~/Forge/Vault",
                overrides = {
                    notes_subdir = "0. Fleeting",
                    new_notes_location = "notes_subdir",
                    daily_notes = {
                        folder = "0. Journal",
                        template = "daily.md",
                    },
                },
            },
            {
                name = "buf-parent",
                path = function()
                    return assert(vim.fs.dirname(vim.api.nvim_buf_get_name(0)))
                end,
                overrides = {
                    notes_subdir = vim.NIL,
                    new_notes_location = "current_dir",
                    templates = {
                        folder = vim.NIL,
                    },
                    disable_frontmatter = true,
                },
            },
        },
        templates = {
            folder = "0. Templates",
        },
        mappings = {
            ["<cr>"] = {
                action = function()
                    return require("obsidian").util.gf_passthrough()
                end,
                opts = { buffer = true, expr = true },
            },
        },
        follow_url_func = function(url)
            local path = url:match("^file://(.+)")
            if path then
                local parent = vim.fn.expand("%:p:h")
                url = "file://localhost/" .. parent .. "/" .. path
                print(url)
            end
            vim.fn.jobstart({ "open", url }) -- Mac OS
        end,
    },
}
