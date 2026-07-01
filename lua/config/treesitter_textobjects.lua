-- Make ]m/[m etc. repeatable with ; and ,
-- Also makes f/F/t/T work through the same repeatable mechanism
local repeat_move = require("nvim-treesitter.textobjects.repeatable_move")
vim.keymap.set({ "n", "x", "o" }, ";", repeat_move.repeat_last_move, { desc = "Repeat last move" })
vim.keymap.set({ "n", "x", "o" }, ",", repeat_move.repeat_last_move_opposite, { desc = "Repeat last move (opposite)" })
vim.keymap.set({ "n", "x", "o" }, "f", repeat_move.builtin_f_expr, { expr = true })
vim.keymap.set({ "n", "x", "o" }, "F", repeat_move.builtin_F_expr, { expr = true })
vim.keymap.set({ "n", "x", "o" }, "t", repeat_move.builtin_t_expr, { expr = true })
vim.keymap.set({ "n", "x", "o" }, "T", repeat_move.builtin_T_expr, { expr = true })
