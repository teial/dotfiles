return {
    "goolord/alpha-nvim",
    lazy = true,
    event = "VimEnter",
    config = function()
        local alpha = require("alpha")
        local dashboard = require("alpha.themes.dashboard")
        dashboard.section.buttons.val = {
            dashboard.button("n", " " .. " New file", ":ene <BAR> startinsert<CR>"),
            dashboard.button("f", " " .. " Find file", ":Telescope find_files<CR>"),
            dashboard.button("g", "󰷾 " .. " Find text", ":Telescope live_grep<CR>"),
            dashboard.button("r", "󰄉 " .. " Recent files", ":Telescope frecency<CR>"),
            dashboard.button("c", " " .. " Config", ":e $MYVIMRC <CR>"),
            dashboard.button("l", "󰒲 " .. " Lazy", ":Lazy<CR>"),
            dashboard.button("q", " " .. " Quit", ":qa<CR>"),
        }
        alpha.setup(dashboard.opts)
    end,
}
