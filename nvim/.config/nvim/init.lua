-- Install lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- Load core config & plugins
require("core")
require("lazy").setup({
    ui = { border = "single" },
    spec = {
        { import = "plugins" },
    },
})

-- Toggel neotree at startup
vim.api.nvim_create_augroup("neotree", {})
vim.api.nvim_create_autocmd("UiEnter", {
    desc = "Open Neotree automatically",
    group = "neotree",
    callback = function()
        if vim.fn.argc() == 0 then
            vim.cmd("Neotree action=focus source=filesystem position=left toggle")
        end
   end,
})
