return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup({
				ui = {
					border = "single",
				},
			})
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					"rust_analyzer",
					"gopls",
					"marksman",
				},
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			local lspconfig = require("lspconfig")
			local handlers = {
				["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "single" }),
				["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "single" }),
			}
			lspconfig.lua_ls.setup({ handlers = handlers })
			lspconfig.rust_analyzer.setup({ handlers = handlers })
			lspconfig.gopls.setup({ handlers = handlers })
			lspconfig.marksman.setup({ handlers = handlers })

			vim.keymap.set("n", "<leader>ch", vim.lsp.buf.hover, { desc = "hover" })
			vim.keymap.set("n", "<leadere>cd", vim.lsp.buf.definition, { desc = "definition" })
			vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "action" })
		end,
	},
}
