return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
    },
    config = function()
        require('neo-tree').setup({
            close_if_last_window = false,
            enable_git_status = true,
            filesystem = {
                follow_current_file = {
                    enabled = true,
                    leave_dirs_open = false,
                },
                group_empty_dirs = true,
            },
            default_component_configs = {
                indent = { indent_size = 3 },
            },
            window = {
                mappings = {
                    ["<space>"] = "open",
                },
            },
            event_handlers = { 
                { 
                    event = "neo_tree_window_after_open", 
                    handler = function() 
                        vim.cmd("setlocal nonumber norelativenumber") 
                    end, 
                },
            },
        })
        vim.keymap.set('n', '<leader>nt', ':Neotree action=show source=filesystem position=left toggle<CR>')
    end
}
