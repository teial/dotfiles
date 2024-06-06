return {
    {
        "lewis6991/gitsigns.nvim",
        config = function()
            require("gitsigns").setup({
                current_line_blame = true,
                on_attach = function(bufnr)
                    local gitsigns = require("gitsigns")
                    local function map(mode, l, r, desc)
                        opts = {
                            buffer = bufnr,
                            desc = desc,
                        }
                        vim.keymap.set(mode, l, r, opts)
                    end

                    -- Navigation
                    map("n", "]c", function()
                        if vim.wo.diff then
                            vim.cmd.normal({ "]c", bang = true })
                        else
                            gitsigns.nav_hunk("next")
                        end
                    end)

                    map("n", "[c", function()
                        if vim.wo.diff then
                            vim.cmd.normal({ "[c", bang = true })
                        else
                            gitsigns.nav_hunk("prev")
                        end
                    end)

                    -- Actions
                    require("which-key").register(
                        { g = { name = "git", t = { "toggle" } } },
                        { prefix = "<leader>", mode = "n", nowait = true }
                    )
                    map("n", "<leader>gs", gitsigns.stage_hunk, "stage hunk")
                    map("n", "<leader>gr", gitsigns.reset_hunk, "reset hunk")
                    map("v", "<leader>gs", function()
                        gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
                    end, "stage hunk")
                    map("v", "<leader>gr", function()
                        gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
                    end, "reset hunk")
                    map("n", "<leader>gS", gitsigns.stage_buffer, "stage buffer")
                    map("n", "<leader>gu", gitsigns.undo_stage_hunk, "unstage hunk")
                    map("n", "<leader>gR", gitsigns.reset_buffer, "reset buffer")
                    map("n", "<leader>gp", gitsigns.preview_hunk, "preview hunk")
                    map("n", "<leader>gb", function()
                        gitsigns.blame_line({ full = true })
                    end, "blame line")
                    map("n", "<leader>gtb", gitsigns.toggle_current_line_blame, "toggle line blame")
                    map("n", "<leader>gd", gitsigns.diffthis, "diff")
                    map("n", "<leader>gD", function()
                        gitsigns.diffthis("~")
                    end, "diff ~")
                    map("n", "<leader>gtd", gitsigns.toggle_deleted, "toggle deleted")

                    -- Text object
                    map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
                end,
            })
        end,
    },
}
