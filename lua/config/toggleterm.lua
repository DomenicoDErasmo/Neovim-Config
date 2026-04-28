require("toggleterm").setup({ direction = "float" })

vim.keymap.set("n", "<leader>tt", "<cmd>ToggleTerm<cr>", { desc = "Start toggleterm" })
