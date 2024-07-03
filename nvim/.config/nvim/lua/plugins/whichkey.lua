return {
    "folke/which-key.nvim",
    config = function()
        vim.o.timeout = true
        vim.o.timeoutlen = 100
        local which = require("which-key")
        which.setup({
            window = { border = "single" },
            triggers_nowait = { "<leader>", "<localleader>" },
        })
        which.register({
            t = "tree",
            f = "files",
            c = "code",
            d = "debug",
            e = "errors",
            r = "repl",
            p = "pomodoro",
        }, { prefix = "<leader>", mode = "n", nowait = true })
    end,
    opts = {},
}
