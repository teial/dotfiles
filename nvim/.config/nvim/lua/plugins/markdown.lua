-- this is to fix bug: https://github.com/folke/which-key.nvim/issues/476
vim.api.nvim_create_autocmd("FileType", {
    desc = "Set up markdown Which-Key descriptions",
    group = vim.api.nvim_create_augroup("markdown_mapping", { clear = true }),
    pattern = "markdown",
    callback = function()
        vim.keymap.set("n", "<localleader>", function()
            require("which-key").show(";")
        end, { buffer = true })
    end,
})

return {
    "qadzek/link.vim"
}
