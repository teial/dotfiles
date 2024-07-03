local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
augroup("__formatter__", { clear = true })
autocmd("BufWritePost", {
    group = "__formatter__",
    command = ":FormatWrite",
})

return {
    "mhartington/formatter.nvim",
    config = function()
        local util = require("formatter.util")
        require("formatter").setup({
            filetype = {
                go = {
                    function()
                        return {
                            exe = "goimports-reviser",
                            args = {
                                "-output",
                                "stdout",
                                "-rm-unused",
                                util.escape_path(util.get_current_buffer_file_path()),
                            },
                            stdin = true,
                        }
                    end,
                    require("formatter.filetypes.go").gofumpt,
                    require("formatter.filetypes.go").golines,
                },
            }
        })
    end
}
