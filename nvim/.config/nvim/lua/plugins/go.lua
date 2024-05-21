-- this is to fix bug: https://github.com/folke/which-key.nvim/issues/476
vim.api.nvim_create_autocmd("FileType", {
    desc = "Set up golang Which-Key descriptions",
    group = vim.api.nvim_create_augroup("golang_mapping", { clear = true }),
    pattern = "go",
    callback = function()
        vim.keymap.set("n", "<localleader>", function()
            require("which-key").show(";")
        end, { buffer = true })
    end,
})

local format_sync_grp = vim.api.nvim_create_augroup("goimports", {})
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.go",
    callback = function()
        require("go.format").goimports()
    end,
    group = format_sync_grp,
})

return {
    "ray-x/go.nvim",
    dependencies = {
        "ray-x/guihua.lua",
        "nvim-treesitter/nvim-treesitter",
    },
    config = function()
        require("go").setup({
            lsp_document_formatting = true,
            lsp_inlay_hints = {
                enable = false, -- let lsp.lua handle it
            },
        })
    end,
    event = { "CmdlineEnter" },
    ft = { "go", "gomod" },
    build = ':lua require("go.install").update_all_sync()',
}
