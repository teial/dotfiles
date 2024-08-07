return {
    "mfussenegger/nvim-dap",
    dependencies = {
        "nvim-neotest/nvim-nio",
        "rcarriga/nvim-dap-ui",
        "leoluz/nvim-dap-go",
    },
    config = function()
        local dap = require("dap")
        local dapui = require("dapui")

        require("dapui").setup()
        require("dap-go").setup()

        dap.listeners.before.attach.dapui_config = function()
            dapui.open()
        end
        dap.listeners.before.launch.dapui_config = function()
            dapui.open()
        end
        dap.listeners.before.event_terminated.dapui_config = function()
            dapui.close()
        end
        dap.listeners.before.event_exited.dapui_config = function()
            dapui.close()
        end

        vim.keymap.set("n", "<Leader>db", dap.toggle_breakpoint, { desc = "toggle breakpoint" })
        vim.keymap.set("n", "<Leader>dc", dap.continue, { desc = "continue" })
        vim.keymap.set("n", "<Leader>do", dap.step_over, { desc = "step over" })
        vim.keymap.set("n", "<Leader>di", dap.step_into, { desc = "step into" })


        dap.adapters.lldb = {
            type = "executable",
            command = "rust-lldb",
            name = "lldb",
        }

        dap.configurations.rust = {
            {
                name = "Launch",
                type = "lldb",
                request = "launch",
                program = function()
                    return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
                end,
                cwd = "${workspaceFolder}",
                stopOnEntry = false,
            },
            {
                name = "Shuttle",
                type = "lldb",
                request = "launch",
                program = "cargo shuttle run",
                cwd = "${workspaceFolder}",
                stopOnEntry = false,
            },
            {
                name = 'Attach',
                type = 'lldb',
                request = 'attach',
                processId = require('dap.utils').pick_process,
                cwd = '${workspaceFolder}',
            },
        }
    end,
}
