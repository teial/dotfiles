return {
    "epwalsh/pomo.nvim",
    version = "*",
    dependencies = {
        "rcarriga/nvim-notify",
    },
    config = function()
        require("pomo").setup({})

        vim.keymap.set("n", "<leader>ps", "<cmd>TimerStart 25m<CR>", { desc = "start" })
        vim.keymap.set("n", "<leader>pt", "<cmd>TimerStop<CR>", { desc = "stop" })
        vim.keymap.set("n", "<leader>pp", "<cmd>TimerPause<CR>", { desc = "pause" })
        vim.keymap.set("n", "<leader>pr", "<cmd>TimerResume<CR>", { desc = "resume" })

        require("telescope").load_extension("pomodori")
        vim.keymap.set("n", "<leader>pl", function()
            require("telescope").extensions.pomodori.timers()
        end, { desc = "list" })
    end,
}
