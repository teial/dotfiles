return {
    "folke/which-key.nvim",
    config = function()
        vim.o.timeout = true
        vim.o.timeoutlen = 100
        local which = require("which-key")
        which.setup({
            window = { border = "single" },
            triggers_nowait = { "<leader>" },
        })
        which.register(
            { t = "toggles", f = "files", c = "code", d = "debug", e = "errors", r = "repl", p = "pomodori" },
            { prefix = "<leader>", mode = "n", nowait = true }
        )
    end,
    opts = {},
}
