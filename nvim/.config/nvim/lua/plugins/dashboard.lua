return {
    "folke/snacks.nvim",
    opts = function(_, opts)
        table.insert(
            opts.dashboard.preset.keys,
            7,
            { icon = "", key = "S", desc = "Select Session", action = require("persistence").select }
        )
    end,
}
