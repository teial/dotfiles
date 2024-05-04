return {
	"rickhowe/wrapwidth",
	config = function()
		-- Soft-wrap at 120 columns
		vim.api.nvim_create_autocmd("BufEnter", {
			pattern = "*.md",
			callback = function()
				vim.opt_local.textwidth = 0
				vim.opt_local.wrap = true
				vim.opt_local.wrapmargin = 0
				vim.opt_local.linebreak = true
				vim.cmd(":Wrapwidth 120")
			end,
		})
	end,
}
