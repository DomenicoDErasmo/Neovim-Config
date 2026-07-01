require("nvim-treesitter.configs").setup({
  ensure_installed = {
    "lua",
    "cpp",
    "python",
    "css",
    "cmake",
    "markdown",
    "markdown_inline",
    "nix",
    "bash",
    "ini",
    "yaml",
    "proto",
    "rust",
  },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = true,
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
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
      set_jumps = true,
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
