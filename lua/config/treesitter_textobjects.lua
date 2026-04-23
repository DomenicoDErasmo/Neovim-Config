require("nvim-treesitter").setup({
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- jump forward to next match if cursor is not on one
      keymaps = {
        ["af"] = { query = "@function.outer", desc = "outer function" },
        ["if"] = { query = "@function.inner", desc = "inner function body" },
        ["ac"] = { query = "@class.outer", desc = "outer class" },
        ["ic"] = { query = "@class.inner", desc = "inner class body" },
        ["aa"] = { query = "@parameter.outer", desc = "outer argument" },
        ["ia"] = { query = "@parameter.inner", desc = "inner argument" },
        ["ab"] = { query = "@block.outer", desc = "outer block" },
        ["ib"] = { query = "@block.inner", desc = "inner block" },
      },
      selection_modes = {
        ["@function.outer"] = "V",
        ["@class.outer"] = "V",
      },
    },

    move = {
      enable = true,
      set_jumps = true, -- add to the jumplist so <C-o>/<C-i> work
      goto_next_start = {
        ["]m"] = { query = "@function.outer", desc = "Next function start" },
        ["]]"] = { query = "@class.outer", desc = "Next class start" },
        ["]a"] = { query = "@parameter.inner", desc = "Next argument" },
      },
      goto_next_end = {
        ["]M"] = { query = "@function.outer", desc = "Next function end" },
        ["]["] = { query = "@class.outer", desc = "Next class end" },
      },
      goto_previous_start = {
        ["[m"] = { query = "@function.outer", desc = "Prev function start" },
        ["[["] = { query = "@class.outer", desc = "Prev class start" },
        ["[a"] = { query = "@parameter.inner", desc = "Prev argument" },
      },
      goto_previous_end = {
        ["[M"] = { query = "@function.outer", desc = "Prev function end" },
        ["[]"] = { query = "@class.outer", desc = "Prev class end" },
      },
    },

    swap = {
      enable = true,
      swap_next = {
        ["<leader>sn"] = { query = "@parameter.inner", desc = "Swap with next argument" },
      },
      swap_previous = {
        ["<leader>sp"] = { query = "@parameter.inner", desc = "Swap with prev argument" },
      },
    },
  },
})

-- Make ]m/[m etc. repeatable with ; and ,
-- Also makes f/F/t/T work through the same repeatable mechanism
local repeat_move = require("nvim-treesitter-textobjects.repeatable_move")
vim.keymap.set({ "n", "x", "o" }, ";", repeat_move.repeat_last_move, { desc = "Repeat last move" })
vim.keymap.set({ "n", "x", "o" }, ",", repeat_move.repeat_last_move_opposite, { desc = "Repeat last move (opposite)" })
vim.keymap.set({ "n", "x", "o" }, "f", repeat_move.builtin_f_expr, { expr = true })
vim.keymap.set({ "n", "x", "o" }, "F", repeat_move.builtin_F_expr, { expr = true })
vim.keymap.set({ "n", "x", "o" }, "t", repeat_move.builtin_t_expr, { expr = true })
vim.keymap.set({ "n", "x", "o" }, "T", repeat_move.builtin_T_expr, { expr = true })
