return {
	"madskjeldgaard/cppman.nvim",
	requires = {
		{ "MunifTanjim/nui.nvim" },
	},
	config = function()
		local cppman = require("cppman")
		cppman.setup()
		vim.keymap.set("n", "<leader>cm", function()
			cppman.open_cppman_for(vim.fn.expand("<cword>"))
		end, { desc = "cpp word search" })
		vim.keymap.set("n", "<leader>cs", function()
			cppman.input()
		end, { desc = "cpp search" })
	end,
}
