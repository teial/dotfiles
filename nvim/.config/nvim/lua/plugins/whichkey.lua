return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	config = function()
		vim.o.timeout = true
		vim.o.timeoutlen = 300
		local which = require("which-key")
		which.setup({
			window = {
				border = "single",
			},
		})
		which.register({ ["<leader>t"] = { desc = "tree" } })
		which.register({ ["<leader>f"] = { desc = "files" } })
		which.register({ ["<leader>c"] = { desc = "code" } })
		which.register({ ["<leader>d"] = { desc = "debug" } })
		which.register({ ["<leader>e"] = { desc = "errors" } })
		which.register({ ["<leader>r"] = { desc = "repl" } })
		which.register({ ["<leader>r"] = { desc = "repl" } })
	end,
	opts = {},
}
