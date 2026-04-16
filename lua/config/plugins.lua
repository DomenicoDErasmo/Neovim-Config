return {
  -- LSP
  {
    "neovim/nvim-lspconfig",
    tag = "v1.8.0",
    event = "BufReadPre",
    dependencies = { "folke/neoconf.nvim" },
    config = function()
      require("config.neoconf")
      require("config.lsp.cpp")
      require("config.lsp.lua")
      require("config.lsp.python")
      require("config.lsp.yaml")
    end,
  },

  -- Async helpers (required by telescope, neogit, obsidian)
  { "nvim-lua/plenary.nvim",                    lazy = true },

  -- Formatting and Linting
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    config = function()
      require("config.conform")
    end,
  },
  { "mfussenegger/nvim-lint",                   ft = { "markdown", "python" } },

  -- Fuzzy file search
  { "nvim-telescope/telescope.nvim",            tag = "0.1.8" },
  { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },

  -- Icons
  { "nvim-tree/nvim-web-devicons" },

  -- Git status for lines changed
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPost",
    config = function()
      require("config.gitsigns")
    end,
  },

  -- Customizable status bar
  { "nvim-lualine/lualine.nvim" },

  -- Highlight TODO comments
  { "folke/todo-comments.nvim" },

  -- Treesitter - Syntax parser
  {
    "nvim-treesitter/nvim-treesitter",
    tag = "v0.9.2",
    event = "BufReadPost",
    config = function()
      require("config.treesitter")
    end,
  },

  -- Colorscheme
  { "Mofiqul/vscode.nvim",    lazy = false, priority = 1000 },

  -- Autocomplete
  {
    "saghen/blink.cmp",
    build = "cargo build --release",
    event = "InsertEnter",
    config = function()
      require("config.blink")
    end,
  },

  -- File browser
  { "stevearc/oil.nvim",      cmd = "Oil" },

  -- Terminal in Vim window
  { "akinsho/toggleterm.nvim" },

  -- Autopairs
  { "windwp/nvim-autopairs" },

  -- Rainbow delimiters
  -- Pinned because errors throw when I insert certain text
  -- Checked as of 2026-04-14
  {
    "HiPhish/rainbow-delimiters.nvim",
    commit = "50080ed0f44dbc18ae13b81278a01b951a06127a",
    event = "BufReadPost",
    config = function()
      require("config.rainbow_delimiters")
    end
  },

  -- Obsidian
  { "obsidian-nvim/obsidian.nvim",               ft = "markdown" },

  -- Markdown rendering
  { "MeanderingProgrammer/render-markdown.nvim", ft = { "markdown" } },

  -- Rainbow CSV
  { "mechatroner/rainbow_csv" },

  -- Keybind popup
  { "folke/which-key.nvim",                      event = "VeryLazy" },

  -- Indentation guide
  { "lukas-reineke/indent-blankline.nvim" },

  -- Diff views
  { "sindrets/diffview.nvim",                    cmd = { "DiffviewOpen", "DiffviewClose" } },

  -- Git UI
  { "NeogitOrg/neogit",                          cmd = { "Neogit" } },

  -- Label-based jumping
  { "folke/flash.nvim",                          event = "VeryLazy" },

  -- Better fold
  { "kevinhwang91/nvim-ufo",                     dependencies = { "kevinhwang91/promise-async" } },

  -- View all LSP errors at once
  { "folke/trouble.nvim",                        cmd = "Trouble" },

  -- Visualize undo history
  { "mbbill/undotree",                           cmd = "UndotreeToggle" },

  -- LSP messages
  { "rcarriga/nvim-notify",                      event = "VeryLazy" },
}
