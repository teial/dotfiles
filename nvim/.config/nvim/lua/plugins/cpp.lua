-- this is to fix bug: https://github.com/folke/which-key.nvim/issues/476
vim.api.nvim_create_autocmd("FileType", {
    desc = "Set up cpp Which-Key descriptions",
    group = vim.api.nvim_create_augroup("cpp_mapping", { clear = true }),
    pattern = "cpp",
    callback = function()
        vim.keymap.set("n", "<localleader>", function()
            require("which-key").show(";")
        end, { buffer = true })
    end,
})

return {
    "madskjeldgaard/cppman.nvim",
    requires = {
        { "MunifTanjim/nui.nvim" },
    },
    config = function()
        require("cppman").setup()
    end,
}
