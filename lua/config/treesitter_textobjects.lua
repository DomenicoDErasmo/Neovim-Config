local ts_main = vim.fn.has("nvim-0.12") == 1

-- On the `master` branch (Neovim <= 0.11) select/move/swap are configured
-- through nvim-treesitter.configs in treesitter_master.lua instead.
local function setup_main()
  require("nvim-treesitter-textobjects").setup({
    select = {
      lookahead = true,
      selection_modes = {
        ["@function.outer"] = "V",
        ["@class.outer"] = "V",
      },
    },
    move = {
      set_jumps = true,
    },
  })

  local select = require("nvim-treesitter-textobjects.select")
  local move = require("nvim-treesitter-textobjects.move")
  local swap = require("nvim-treesitter-textobjects.swap")

  local select_maps = {
    af = { "@function.outer", "outer function" },
    ["if"] = { "@function.inner", "inner function body" },
    ac = { "@class.outer", "outer class" },
    ic = { "@class.inner", "inner class body" },
    aa = { "@parameter.outer", "outer argument" },
    ia = { "@parameter.inner", "inner argument" },
    ab = { "@block.outer", "outer block" },
    ib = { "@block.inner", "inner block" },
  }
  for lhs, m in pairs(select_maps) do
    vim.keymap.set({ "x", "o" }, lhs, function()
      select.select_textobject(m[1], "textobjects")
    end, { desc = m[2] })
  end

  local move_maps = {
    goto_next_start = {
      ["]m"] = { "@function.outer", "Next function start" },
      ["]]"] = { "@class.outer", "Next class start" },
      ["]a"] = { "@parameter.inner", "Next argument" },
    },
    goto_next_end = {
      ["]M"] = { "@function.outer", "Next function end" },
      ["]["] = { "@class.outer", "Next class end" },
    },
    goto_previous_start = {
      ["[m"] = { "@function.outer", "Prev function start" },
      ["[["] = { "@class.outer", "Prev class start" },
      ["[a"] = { "@parameter.inner", "Prev argument" },
    },
    goto_previous_end = {
      ["[M"] = { "@function.outer", "Prev function end" },
      ["[]"] = { "@class.outer", "Prev class end" },
    },
  }
  for fn, maps in pairs(move_maps) do
    for lhs, m in pairs(maps) do
      vim.keymap.set({ "n", "x", "o" }, lhs, function()
        move[fn](m[1], "textobjects")
      end, { desc = m[2] })
    end
  end

  vim.keymap.set("n", "<leader>sn", function()
    swap.swap_next("@parameter.inner")
  end, { desc = "Swap with next argument" })
  vim.keymap.set("n", "<leader>sp", function()
    swap.swap_previous("@parameter.inner")
  end, { desc = "Swap with prev argument" })
end

if ts_main then
  setup_main()
end

-- Make ]m/[m etc. repeatable with ; and ,
-- Also makes f/F/t/T work through the same repeatable mechanism
local repeat_move =
  require(ts_main and "nvim-treesitter-textobjects.repeatable_move" or "nvim-treesitter.textobjects.repeatable_move")
vim.keymap.set({ "n", "x", "o" }, ";", repeat_move.repeat_last_move, { desc = "Repeat last move" })
vim.keymap.set({ "n", "x", "o" }, ",", repeat_move.repeat_last_move_opposite, { desc = "Repeat last move (opposite)" })
vim.keymap.set({ "n", "x", "o" }, "f", repeat_move.builtin_f_expr, { expr = true })
vim.keymap.set({ "n", "x", "o" }, "F", repeat_move.builtin_F_expr, { expr = true })
vim.keymap.set({ "n", "x", "o" }, "t", repeat_move.builtin_t_expr, { expr = true })
vim.keymap.set({ "n", "x", "o" }, "T", repeat_move.builtin_T_expr, { expr = true })
