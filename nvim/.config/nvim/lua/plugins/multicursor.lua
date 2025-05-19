return {
    "jake-stewart/multicursor.nvim",
    branch = "1.0",
    keys = {
        { "<M-k>", function() require("multicursor-nvim").lineAddCursor(-1) end },
        { "<M-j>", function() require("multicursor-nvim").lineAddCursor(1) end },
        { "<M-K>", function() require("multicursor-nvim").lineSkipCursor(-1) end },
        { "<M-J>", function() require("multicursor-nvim").lineSkipCursor(1) end },
    },
    config = function()
        local mc = require("multicursor-nvim")
        mc.setup()

        -- Add or skip adding a new cursor by matching word/selection
        -- set({ "n", "x" }, "<localleader>n", function() mc.matchAddCursor(1) end)
        -- set({ "n", "x" }, "<localleader>s", function() mc.matchSkipCursor(1) end)
        -- set({ "n", "x" }, "<localleader>N", function() mc.matchAddCursor(-1) end)
        -- set({ "n", "x" }, "<localleader>S", function() mc.matchSkipCursor(-1) end)

        -- Mappings defined in a keymap layer only apply when there are
        -- multiple cursors. This lets you have overlapping mappings.
        mc.addKeymapLayer(function(layerSet)
            -- Select a different cursor as the main one.
            layerSet({ "n", "x" }, "<left>", mc.prevCursor)
            layerSet({ "n", "x" }, "<right>", mc.nextCursor)

            -- Delete the main cursor.
            -- layerSet({ "n", "x" }, "<leader>x", mc.deleteCursor)

            -- Enable and clear cursors using escape.
            layerSet("n", "<esc>", function()
                if not mc.cursorsEnabled() then
                    mc.enableCursors()
                else
                    mc.clearCursors()
                end
            end)
        end)

        -- Customize how cursors look.
        local hl = vim.api.nvim_set_hl
        hl(0, "MultiCursorCursor", { reverse = true })
        hl(0, "MultiCursorVisual", { link = "Visual" })
        hl(0, "MultiCursorSign", { link = "SignColumn" })
        hl(0, "MultiCursorMatchPreview", { link = "Search" })
        hl(0, "MultiCursorDisabledCursor", { reverse = true })
        hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
        hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })
    end,
}
