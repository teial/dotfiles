return {
    {
        "williamboman/mason.nvim",
        opts = {
            ui = {
                border = "single",
            },
        },
    },
    {
        "williamboman/mason-lspconfig.nvim",
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "clangd",
                    "marksman",
                    "taplo",
                    "jdtls",
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

            lspconfig.clangd.setup({
                handlers = handlers,
                capabilities = capabilities,
                cmd = {
                    "clangd",
                    "--background-index",
                    "--clang-tidy",
                    "--header-insertion=iwyu",
                    "--completion-style=detailed",
                },
            })

            lspconfig.elixirls.setup({
                handlers = handlers,
                capabilities = capabilities,
                cmd = { "elixir-ls" },
                settings = {
                    elixirLS = {
                        dialyzerEnabled = true,
                        incrementalDialyzer = true,
                    },
                },
            })

            lspconfig.zls.setup({
                handlers = handlers,
                capabilities = capabilities,
                settings = {
                    zls = {
                        cmd = "zls",
                        enable_inlay_hints = true,
                        inlay_hints_show_parameter_name = false,
                        warn_style = true,
                    },
                },
            })

            lspconfig.gopls.setup({
                handlers = handlers,
                capabilities = capabilities,
                settings = {
                    gopls = {
                        hints = {
                            assignVariableTypes = true,
                            compositeLiteralFields = false,
                            compositeLiteralTypes = false,
                            constantValues = true,
                            functionTypeParameters = false,
                            parameterNames = false,
                            rangeVariableTypes = true,
                        },
                    },
                },
            })

            lspconfig.lua_ls.setup({
                handlers = handlers,
                capabilities = capabilities,
                settings = {
                    Lua = {
                        cmd = "lua-language-server",
                        diagnostics = {
                            globals = { "vim" },
                        },
                    },
                },
            })

            lspconfig.nil_ls.setup({
                handlers = handlers,
                capabilities = capabilities,
                settings = {
                    Nix = {
                        cmd = "nil",
                        formatting = {
                            command = { "nixfmt" },
                        },
                    },
                },
            })

            -- lspconfig.julials.setup(opts)

            -- Remove or refactor these to work with nix binaries.
            lspconfig.marksman.setup(opts)
            lspconfig.taplo.setup(opts)

            vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "hover" })
            vim.keymap.set("n", "<leader>cD", vim.lsp.buf.declaration, { desc = "declaration" })
            vim.keymap.set("n", "<leader>cd", vim.lsp.buf.definition, { desc = "definition" })
            vim.keymap.set("n", "<leader>cr", vim.lsp.buf.references, { desc = "references" })
            vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "action" })
            vim.keymap.set("n", "<leader>cc", vim.lsp.buf.rename, { desc = "rename" })
        end,
    },
}
