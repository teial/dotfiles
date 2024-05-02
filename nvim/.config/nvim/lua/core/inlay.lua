local lsp = vim.lsp

-- Set up inlay hints everywhere by default
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    callback = function(args)
        local client = lsp.get_client_by_id(args.data.client_id)
        if client.server_capabilities.inlayHintProvider then
            lsp.inlay_hint.enable(true, { bufnr = args.buf })
        end
    end,
})

-- Easy key to toggle
vim.keymap.set("n", "<leader>ch", function()
    local inlay_hint_enabled = lsp.inlay_hint.is_enabled({ bufnr = 0 })
    lsp.inlay_hint.enable(not inlay_hint_enabled, { bufnr = 0 })
end, { desc = "inlay hints" })
