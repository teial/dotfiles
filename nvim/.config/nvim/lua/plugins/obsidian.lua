return {
    "obsidian-nvim/obsidian.nvim",
    version = "*",
    lazy = true,
    ft = "markdown",
    dependencies = {
        "nvim-lua/plenary.nvim",
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
                path = "~/Forge/teial",
                overrides = {
                    daily_notes = {
                        folder = "1-daily",
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
            folder = "0-system/templates",
        },
        mappings = {
            ["<cr>"] = {
                action = function()
                    return require("obsidian").util.gf_passthrough()
                end,
                opts = { buffer = true, expr = true },
            },
            ["<leader>oc"] = {
                action = function()
                    return require("obsidian").util.toggle_checkbox()
                end,
                opts = { buffer = true, desc = "toggle checkbox" },
            },
            ["<leader>od"] = {
                action = "<cmd>ObsidianToday<CR>",
                opts = { buffer = true, desc = "today" },
            },
            ["<leader>oy"] = {
                action = "<cmd>ObsidianToday -1<CR>",
                opts = { buffer = true, desc = "yesterday" },
            },
            ["<leader>om"] = {
                action = "<cmd>ObsidianToday 1<CR>",
                opts = { buffer = true, desc = "tomorrow" },
            },
            ["<leader>on"] = {
                action = "<cmd>ObsidianNew<CR>",
                opts = { buffer = true, desc = "new note" },
            },
            ["<leader>ob"] = {
                action = "<cmd>ObsidianBacklinks<CR>",
                opts = { buffer = true, desc = "backlinks" },
            },
            ["<leader>os"] = {
                action = "<cmd>ObsidianSearch<CR>",
                opts = { buffer = true, desc = "search" },
            },
            ["<leader>ot"] = {
                action = "<cmd>ObsidianTags<CR>",
                opts = { buffer = true, desc = "tags" },
            },
            ["<leader>oq"] = {
                action = "<cmd>ObsidianQuickSwitch<CR>",
                opts = { buffer = true, desc = "quick switch" },
            },
            ["<leader>ow"] = {
                action = "<cmd>ObsidianWorkspace<CR>",
                opts = { buffer = true, desc = "workspace" },
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
            -- vim.fn.jobstart({"xdg-open", url})  -- linux
        end,
    },
}
