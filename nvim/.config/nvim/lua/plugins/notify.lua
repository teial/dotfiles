return {
    "rcarriga/nvim-notify",
    config = function()
        require("notify").setup({
            stages = "static",
        })

        -- Telescope integration
        vim.keymap.set("n", "<leader>fn", require("telescope").extensions.notify.notify, { desc = "notifications" })
    end,
}
