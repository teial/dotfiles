vim.keymap.set("n", "<localleader>r", "<cmd>require('java').test.run_current_class()<CR>", { desc = "Run Java Test" })
vim.keymap.set("n", "<localleader>d", "<cmd>require('java').test.debug_current_class()<CR>", { desc = "Debug Java Test" })
