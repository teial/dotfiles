return {
    "neovim/nvim-lspconfig",
    opts = {
        servers = {
            marksman = {
                on_attach = function(client, bufnr)
                    client.handlers["textDocument/publishDiagnostics"] = function() end
                end,
            },
        },
    },
}
