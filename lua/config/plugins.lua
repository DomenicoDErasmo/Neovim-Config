local function cfg(name)
  return function() require("config." .. name) end
end

return {
  -- LSP configs (uses vim.lsp.config / vim.lsp.enable directly;
  -- neoconf is for per-project overrides and depends on lspconfig.util at runtime)
  {
    "folke/neoconf.nvim",
    event = "BufReadPre",
    dependencies = { "neovim/nvim-lspconfig" },
    config = function()
      require("neoconf").setup({
        local_settings = { ".neoconf.json", ".vim/neoconf.json" },
      })
      -- Workaround for neoconf upstream bug (commands.lua:107 concatenates
      -- local_settings as a string). local_patterns is already populated from
      -- the table above; this only affects the "create new file" fallback in
      -- :Neoconf, which expects a single string.
      require("neoconf.config").options.local_settings = ".neoconf.json"
      require("config.lsp.cpp")
      require("config.lsp.lua")
      require("config.lsp.python")
      require("config.lsp.proto")
      require("config.lsp.rust")
    end,
  },

  -- Async helpers (required by telescope, neogit, obsidian)
  { "nvim-lua/plenary.nvim",                    lazy = true },

  -- Formatting and Linting
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    config = cfg("conform"),
  },
  {
    "mfussenegger/nvim-lint",
    ft = { "markdown", "python" },
    config = cfg("nvim_lint"),
  },

  -- Fuzzy file search
  {
    "nvim-telescope/telescope.nvim",
    config = cfg("telescope"),
  },
  { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },

  -- Icons
  { "nvim-tree/nvim-web-devicons" },

  -- Git status for lines changed
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPost",
    config = cfg("gitsigns"),
  },

  -- Customizable status bar
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    config = cfg("lualine"),
  },

  -- Highlight TODO comments
  {
    "folke/todo-comments.nvim",
    event = "BufReadPost",
    config = cfg("todo_comments"),
  },

  -- Treesitter - Syntax parser
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    build = ":TSUpdate",
    event = "BufReadPost",
    config = cfg("treesitter"),
  },

  -- Treesitter text objects (select/move/swap by function, class, argument, block)
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "master",
    event = "BufReadPost",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = cfg("treesitter_textobjects"),
  },

  -- Sticky header showing the enclosing function/class while scrolling
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "BufReadPost",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("treesitter-context").setup({ max_lines = 3 })
    end,
  },

  -- Colorscheme
  {
    "Mofiqul/vscode.nvim",
    lazy = false,
    priority = 1000,
    config = cfg("colorscheme"),
  },

  -- Autocomplete
  { "rafamadriz/friendly-snippets" },
  { "saghen/blink.compat", version = "*", lazy = true, opts = {} },
  { "rcarriga/cmp-dap" },
  {
    "saghen/blink.cmp",
    build = "cargo build --release",
    event = "InsertEnter",
    dependencies = { "saghen/blink.compat", "rcarriga/cmp-dap" },
    config = cfg("blink"),
    version = "1.*",
  },

  -- File browser
  {
    "stevearc/oil.nvim",
    config = function()
      require("oil").setup({
        win_options = { signcolumn = "yes:3" },
      })
      require("config.oil_lsp_diag")
    end,
  },

  -- Terminal in Vim window
  {
    "akinsho/toggleterm.nvim",
    cmd = "ToggleTerm",
    keys = { { "<leader>tt", "<cmd>ToggleTerm<cr>", desc = "Start toggleterm" } },
    config = cfg("toggleterm"),
  },

  -- Autopairs
  { "windwp/nvim-autopairs",               config = function() require("nvim-autopairs").setup({}) end },

  -- Rainbow delimiters
  -- Pinned because errors throw when I insert certain text
  -- Checked as of 2026-04-14
  {
    "HiPhish/rainbow-delimiters.nvim",
    event = "BufReadPost",
    config = cfg("rainbow_delimiters"),
  },

  -- Obsidian
  {
    "obsidian-nvim/obsidian.nvim",
    ft = "markdown",
    config = cfg("obsidian"),
  },

  -- Markdown rendering
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown" },
    config = cfg("render_markdown"),
  },

  -- Rainbow CSV
  { "mechatroner/rainbow_csv",             ft = { "csv", "tsv" } },

  -- Keybind popup
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = cfg("which_key"),
  },

  -- Indentation guide
  { "lukas-reineke/indent-blankline.nvim", config = function() require("ibl").setup() end },

  -- Diff views
  { "sindrets/diffview.nvim",              cmd = { "DiffviewOpen", "DiffviewClose" } },

  -- Git UI
  { "NeogitOrg/neogit",                    cmd = { "Neogit" } },

  -- Better fold
  {
    "kevinhwang91/nvim-ufo",
    event = "BufReadPost",
    dependencies = { "kevinhwang91/promise-async" },
    config = cfg("ufo"),
  },

  -- View all LSP errors at once
  { "folke/trouble.nvim",                  config = cfg("trouble") },

  -- Visualize undo history
  { "mbbill/undotree",                     cmd = "UndotreeToggle" },

  -- LSP messages
  {
    "rcarriga/nvim-notify",
    lazy = false,
    config = cfg("notify"),
  },

  -- Git status in oil buffers
  {
    "refractalize/oil-git-status.nvim",
    config = function()
      require("oil-git-status").setup()
    end,
  },

  -- Python venv selector
  {
    "linux-cultist/venv-selector.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    ft = "python",
    keys = {
      { "<leader>pv", "<cmd>VenvSelect<cr>", desc = "Select venv" },
    },
    config = function()
      vim.schedule(function()
        -- Point $NVIM_VENV_DIR at a directory of shared venvs to add a custom
        -- search; otherwise fall back to venv-selector's default searches.
        local venv_dir = os.getenv("NVIM_VENV_DIR")
        require("venv-selector").setup({
          options = {
            enable_default_searches = venv_dir == nil,
            on_venv_activate_callback = function()
              local python = require("venv-selector").python()
              if python then
                require("dap-python").setup(python)
              end
            end,
          },
          search = venv_dir and {
            shared = { command = "$FD '/bin/python$' " .. venv_dir .. " --full-path --color never" },
          } or nil,
        })
      end)
    end,
  },

  -- Debugger
  {
    "mfussenegger/nvim-dap",
    event = "VeryLazy",
    dependencies = {
      { "rcarriga/nvim-dap-ui", dependencies = { "nvim-neotest/nvim-nio" } },
      "mfussenegger/nvim-dap-python",
      "theHamsta/nvim-dap-virtual-text",
    },
    config = cfg("dap"),
  },

  -- Find and replace with ripgrep
  {
    "MagicDuck/grug-far.nvim",
    cmd = "GrugFar",
    config = function()
      require("grug-far").setup({
        openTargetWindow = { preferredLocation = "prev" },
      })
    end,
  },
}
