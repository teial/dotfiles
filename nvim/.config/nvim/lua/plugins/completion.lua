return {
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "onsails/lspkind.nvim"
        },
        config = function()
            local cmp = require("cmp")
            local lspkind = require('lspkind')
            require("luasnip.loaders.from_vscode").lazy_load()

            cmp.setup({
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end,
                },
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-n>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-p>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                }),
                sources = cmp.config.sources({
                    { name = 'async-path' },
                    { name = "copilot",   keyword_length = 3 },
                    { name = 'nvim_lsp',  keyword_length = 1 },
                    { name = 'buffer',    keyword_length = 3 },
                    { name = 'luasnip',   keyword_length = 2 },
                }, {
                    { name = "buffer" },
                }),
                formatting = {
                    format = lspkind.cmp_format({
                        mode = "symbol",
                        max_width = 50,
                        symbol_map = { Copilot = "" }
                    })
                }
            })
        end,
    },
    {
        "L3MON4D3/LuaSnip",
        dependencies = {
            "saadparwaiz1/cmp_luasnip",
            "rafamadriz/friendly-snippets",
        },
    },
    {
        "hrsh7th/cmp-nvim-lsp",
    },
    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        config = function()
            require("copilot").setup({
                panel = { enabled = false },
                suggestion = {
                    auto_trigger = false,
                    keymap = {
                        accept = "<C-d>",
                        next = "<C-n>",
                        prev = "<C-p>",
                        accept_word = "<M-w>",
                        accept_line = "<M-l>",
                        dismiss = "<C-e>",
                    },
                },
            })
        end,
    },
}
