return {
    "danymat/neogen",
    config = true,
    keys = {
        { "<leader>cg", ":lua require('neogen').generate()<CR>", desc = "annotate", { noremap = true, silent = true } },
    },
}
