return {
    "folke/snacks.nvim",
    opts = function(_, opts)
        table.insert(
            opts.dashboard.preset.keys,
            7,
            { icon = "", key = "S", desc = "Select Session", action = require("persistence").select }
        )
        table.insert(
            opts.dashboard.preset.keys,
            9,
            { icon = "⚲", key = "m", desc = "Mason", action = function() vim.cmd.Mason() end }
        )
    end,
}
