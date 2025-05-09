-- Big ugly hack. I copied new_from_template because I couldn't rebind new_notes_location
-- in the call to Obsidian comannd.
local function save_fleeting()
    local client = require("obsidian").get_client()
    local picker = client:picker()
    if not picker then
        return
    end

    -- Get title from the user
    local util = require("obsidian.util")
    local title = util.input("Enter title or path (optional): ", { completion = "file" })
    if not title then
        return
    elseif title == "" then
        title = nil
    end

    local notes_subdir = client.current_workspace.overrides.notes_subdir
    picker:find_templates({
        callback = function(name)
            if name == nil or name == "" then
                return
            end
            ---@type obsidian.Note
            local note = client:create_note({ title = title, template = name, dir = notes_subdir, no_write = false })
            client:open_note(note, { sync = false })
        end,
    })
end

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
        {
            "<leader>onf",
            function()
                save_fleeting()
            end,
            desc = "new fleeting note",
        },
        { "<leader>onn", "<cmd>ObsidianNew<CR>", desc = "new note" },
        { "<leader>onp", "<cmd>Obsidian new_from_template<CR>", desc = "new from template" },
        { "<leader>ont", "<cmd>Obsidian template<CR>", desc = "insert template" },
        { "<leader>ojj", "<cmd>ObsidianToday<CR>", desc = "today" },
        { "<leader>ojy", "<cmd>ObsidianToday -1<CR>", desc = "yesterday" },
        { "<leader>ojt", "<cmd>ObsidianToday 1<CR>", desc = "tomorrow" },
        { "<leader>oo", "<cmd>ObsidianOpen<CR>", desc = "open in obsidian" },
        { "<leader>ob", "<cmd>ObsidianBacklinks<CR>", desc = "backlinks" },
        { "<leader>os", "<cmd>ObsidianSearch<CR>", desc = "search" },
        { "<leader>ot", "<cmd>ObsidianTags<CR>", desc = "tags" },
        { "<leader>oq", "<cmd>ObsidianQuickSwitch<CR>", desc = "quick switch" },
        { "<leader>oq", "<cmd>ObsidianWorkspace<CR>", desc = "workspace" },
        { "<leader>oll", "<cmd>Obsidian link<CR>", desc = "link", mode = { "n", "v" } },
        { "<leader>oln", "<cmd>Obsidian link_new<CR>", desc = "link new", mode = { "n", "v" } },
        { "<leader>ola", "<cmd>Obsidian links<CR>", desc = "all links" },
    },
    opts = {
        open_app_foreground = true,
        picker = {
            name = "snacks.pick",
        },
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
                    new_notes_location = "current_dir",
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
