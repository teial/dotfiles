local lsp = vim.lsp

-- Set up inlay hints everywhere by default
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(args)
		local client = lsp.get_client_by_id(args.data.client_id)
		if client.server_capabilities.inlayHintProvider then
			lsp.inlay_hint.enable(args.buf, true)
		end
	end,
})

-- Easy key to toggle
vim.keymap.set("n", "<leader>ch", function()
	lsp.inlay_hint.enable(0, not lsp.inlay_hint.is_enabled())
end, { desc = "inlay hints" })
