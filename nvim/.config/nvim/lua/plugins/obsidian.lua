return {
    "epwalsh/obsidian.nvim",
    version = "*",
    lazy = true,
    ft = "markdown",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    config = function()
        local obsidian = require("obsidian")
        obsidian.setup({
            workspaces = {
                {
                    name = "teial",
                    path = "~/Drive/teial",
                    overrides = {
                        notes_subdir = "teial/5-garden",
                        daily_notes = {
                            folder = "teial/0-daily",
                        },
                    },
                },
                {
                    name = "ritm",
                    path = "~/Drive/ritm",
                    overrides = {
                        notes_subdir = "ritm/issues",
                        daily_notes = {
                            folder = "ritm/daily",
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
            callbacks = {
                post_set_workspace = function(client, workspace)
                    local root_file = vim.fs.joinpath(workspace.path.filename, 'meta.md')
                    if vim.fn.filereadable(root_file) then
                        vim.api.nvim_set_current_dir(workspace.path.filename)
                        vim.cmd.edit(root_file)
                    end
                end,
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
        })
        require("which-key").register({ ["<leader>o"] = { desc = "obsidian" } })
        vim.keymap.set("n", "<leader>oc", "<cmd>ObsidianToggleCheckbox<CR>", { desc = "checkbox" })
        vim.keymap.set("n", "<leader>od", "<cmd>ObsidianToday<CR>", { desc = "today" })
        vim.keymap.set("n", "<leader>oy", "<cmd>ObsidianToday -1<CR>", { desc = "yesterday" })
        vim.keymap.set("n", "<leader>om", "<cmd>ObsidianToday 1<CR>", { desc = "tomorrow" })
        vim.keymap.set("n", "<leader>od", "<cmd>ObsidianDailies<CR>", { desc = "dailies" })
        vim.keymap.set("n", "<leader>on", "<cmd>ObsidianNew<CR>", { desc = "new note" })
        vim.keymap.set("n", "<leader>ob", "<cmd>ObsidianBacklinks<CR>", { desc = "backlinks" })
        vim.keymap.set("n", "<leader>os", "<cmd>ObsidianSearch<CR>", { desc = "search" })
        vim.keymap.set("n", "<leader>ot", "<cmd>ObsidianTags<CR>", { desc = "tags" })
        vim.keymap.set("n", "<leader>oq", "<cmd>ObsidianQuickSwitch<CR>", { desc = "quick switch" })
        vim.keymap.set("n", "<leader>of", "<cmd>ObsidianFollowLink<CR>", { desc = "follow" })
        vim.keymap.set("n", "<leader>ow", "<cmd>ObsidianWorkspace<CR>",
            { desc = "workspace" })
    end,
}
