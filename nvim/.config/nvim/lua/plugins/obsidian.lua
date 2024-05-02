return {
	"epwalsh/obsidian.nvim",
	version = "*",
	lazy = true,
	ft = "markdown",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	config = function()
		local obsidian = require("obsidian")
		obsidian.setup({
			workspaces = {
				{
					name = "teial",
					path = "~/Drive/teial",
				},
			},
			daily_notes = {
				path = "~/Drive/teial/daily",
			},
		})
		which.register({ ["<leader>o"] = { desc = "obsidian" } })
		vim.keymap.set("n", "<leader>oc", obsidian.util.toggle_checkbox, { desc = "checkbox" })
		vim.keymap.set("n", "<leader>od", obsidian.util.today, { desc = "today" })
		vim.keymap.set("n", "<leader>oy", obsidian.util.yesterday, { desc = "yesterday" })
		vim.keymap.set("n", "<leader>om", obsidian.util.tomorrow, { desc = "tomorrow" })
		vim.keymap.set("n", "<leader>od", obsidian.util.dailies, { desc = "dailies" })
		vim.keymap.set("n", "<leader>on", obsidian.util.new, { desc = "new note" })
		vim.keymap.set("n", "<leader>ob", obsidian.util.backlinks, { desc = "backlinks" })
		vim.keymap.set("n", "<leader>os", obsidian.util.search, { desc = "search" })
		vim.keymap.set("n", "<leader>ot", obsidian.util.tags, { desc = "tags" })
		vim.keymap.set("n", "<leader>oq", obsidian.util.quick_switch, { desc = "quick switch" })
		vim.keymap.set("n", "<leader>of", obsidian.util.follow_link, { desc = "follow" })
		vim.keymap.set("n", "<leader>ow", obsidian.util.workspace, { desc = "workspace" })
	end,
}
