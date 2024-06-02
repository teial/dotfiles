return {
    "mrcjkb/haskell-tools.nvim",
    version = "^3",
    ft = { "haskell", "lhaskell", "cabal", "cabalproject" },
    config = function()
        local ht = require("haskell-tools")
        local bufnr = vim.api.nvim_get_current_buf()
        vim.keymap.set(
            "n",
            "<leader>cl",
            vim.lsp.codelens.run,
            { noremap = true, silent = true, buffer = bufnr, desc = "lens" }
        )
        vim.keymap.set(
            "n",
            "<leader>cs",
            ht.hoogle.hoogle_signature,
            { noremap = true, silent = true, buffer = bufnr, desc = "hoogle" }
        )
        vim.keymap.set(
            "n",
            "<leader>ce",
            ht.lsp.buf_eval_all,
            { noremap = true, silent = true, buffer = bufnr, desc = "evaluate" }
        )
        vim.keymap.set(
            "n",
            "<leader>rr",
            ht.repl.toggle,
            { noremap = true, silent = true, buffer = bufnr, desc = "package" }
        )
        vim.keymap.set("n", "<leader>rf", function()
            ht.repl.toggle(vim.api.nvim_buf_get_name(0))
        end, { noremap = true, silent = true, buffer = bufnr, desc = "buffer" })
        vim.keymap.set(
            "n",
            "<leader>rq",
            ht.repl.quit,
            { noremap = true, silent = true, buffer = bufnr, desc = "quit" }
        )
    end,
}
