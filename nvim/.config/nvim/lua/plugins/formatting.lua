return {
    "elentok/format-on-save.nvim",
    config = function()
        local formatters = require("format-on-save.formatters")
        require("format-on-save").setup({
            experiments = {
                partial_update = "diff",
            },
            formatter_by_ft = {
                css = formatters.lsp,
                html = formatters.lsp,
                java = formatters.lsp,
                json = formatters.lsp,
                lua = formatters.lsp,
                python = formatters.black,
                rust = formatters.lsp,
                haskell = formatters.lsp,
                sh = formatters.shfmt,
                yaml = formatters.lsp,
                nix = formatters.lsp,
                go = {
                    formatters.shell({
                        cmd = { "goimports-reviser", "-rm-unused", "-set-alias", "-format", "%" },
                        tempfile = function()
                            return vim.fn.expand("%") .. ".formatter-temp"
                        end,
                    }),
                    formatters.shell({ cmd = { "gofmt" } }),
                },
            },
        })
    end,
}
