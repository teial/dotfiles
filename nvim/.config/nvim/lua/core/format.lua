-- Default line wrapping and width
vim.opt_local.wrap = false
vim.opt_local.textwidth = 120

-- Move inside softly-wrapped block
vim.keymap.set("n", "j", "gj")
vim.keymap.set("n", "k", "gk")

-- Autoformat
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("lsp", { clear = true }),
	callback = function(args)
		vim.api.nvim_create_autocmd("BufWritePre", {
			buffer = args.buf,
			callback = function()
				vim.lsp.buf.format({ async = false, id = args.data.client_id })
			end,
		})
	end,
})
