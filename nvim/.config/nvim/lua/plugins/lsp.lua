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
					"clangd",
					"lua_ls",
					"marksman",
					"taplo",
					"jdtls",
					"gopls",
				},
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			local lspconfig = require("lspconfig")
			local util = require("lspconfig/util")
			local handlers = {
				["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "single" }),
				["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "single" }),
			}
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local opts = { handlers = handlers, capabilities = capabilities }

			lspconfig.clangd.setup(opts)
			lspconfig.lua_ls.setup(opts)
			lspconfig.marksman.setup(opts)
			lspconfig.taplo.setup(opts)
			lspconfig.jdtls.setup(opts)
			lspconfig.gopls.setup(opts)

			vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "hover" })
			vim.keymap.set("n", "<leader>cD", vim.lsp.buf.declaration, { desc = "declaration" })
			vim.keymap.set("n", "<leader>cd", vim.lsp.buf.definition, { desc = "definition" })
			vim.keymap.set("n", "<leader>cr", vim.lsp.buf.references, { desc = "references" })
			vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "action" })
			vim.keymap.set("n", "<leader>cc", vim.lsp.buf.rename, { desc = "rename" })
		end,
	},
}
