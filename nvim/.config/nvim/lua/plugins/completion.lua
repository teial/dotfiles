return {
    {
        "hrsh7th/nvim-cmp",
        version = false,
        event = "InsertEnter",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "onsails/lspkind.nvim",
            "Arkissa/cmp-agda-symbols",
            "supermaven-inc/supermaven-nvim",
        },
        opts = function()
            local lspkind = require("lspkind")
            local cmp = require("cmp")
            local auto_select = true
            return {
                auto_brackets = {}, -- configure any filetype to auto add brackets
                sources = cmp.config.sources({
                    { name = "supermaven", group_index = 1, priority = 100 }, -- Supermaven
                    { name = "async-path" }, -- filesystem paths
                    { name = "lazydev" }, -- faster LuaLS completions
                    { name = "nvim_lsp", keyword_length = 1 }, -- LSP completions
                    { name = "agda-symbols", keyword_length = 1 }, -- Agda symbols
                }, {
                    { name = "buffer" }, -- completions from the current buffer
                }),
                mapping = cmp.mapping.preset.insert({
                    ["<C-n>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-p>"] = cmp.mapping.scroll_docs(4),
                    ["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
                    ["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
                    ["<C-d>"] = cmp.mapping.complete(),
                    ["<CR>"] = LazyVim.cmp.confirm({ select = auto_select }),
                    ["<C-CR>"] = function(fallback)
                        cmp.abort()
                        fallback()
                    end,
                    ["<tab>"] = function(fallback)
                        return LazyVim.cmp.map({ "snippet_forward", "ai_accept" }, fallback)()
                    end,
                }),
                formatting = {
                    format = lspkind.cmp_format({
                        mode = "symbol_text",
                        max_width = 50,
                        symbol_map = { Copilot = "", Supermaven = "" },
                    }),
                },
            }
        end,
    },
}
