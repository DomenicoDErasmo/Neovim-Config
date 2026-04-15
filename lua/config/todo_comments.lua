require("todo-comments").setup()

vim.keymap.set("n", "<leader>fT", "<cmd>TodoTelescope<cr>", { desc = "find todos" })
