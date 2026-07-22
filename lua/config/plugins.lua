local function cfg(name)
  return function()
    require("config." .. name)
  end
end

-- Telescope find_files, optionally including hidden files. Always skips .git.
local function find_files(hidden)
  return function()
    local find_command = { "rg", "--files", "--glob", "!.git/*" }
    if hidden then
      table.insert(find_command, "--hidden")
    end
    require("telescope.builtin").find_files({ find_command = find_command })
  end
end

-- Call a telescope.builtin picker by name, with optional static opts.
local function builtin(name, opts)
  return function()
    require("telescope.builtin")[name](opts)
  end
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
  { "nvim-lua/plenary.nvim", lazy = true },

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
    dependencies = {
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    cmd = "Telescope",
    keys = {
      {
        "<leader>fa",
        find_files(false),
        desc = "Telescope find files (exclude hidden files)",
      },
      {
        "<leader>ff",
        find_files(true),
        desc = "Telescope find files",
      },
      {
        "<leader>fg",
        builtin("live_grep"),
        desc = "Telescope live grep",
      },
      {
        "<leader>fG",
        builtin("live_grep", { additional_args = { "--fixed-strings" } }),
        desc = "Telescope live grep (exact)",
      },
      {
        "<leader>ft",
        function()
          require("telescope.builtin").live_grep({
            prompt_title = "Live Grep (filetype)",
            additional_args = function()
              local glob = vim.fn.input("Glob filter: ")
              return glob ~= "" and { "--glob", glob } or {}
            end,
          })
        end,
        desc = "Telescope live grep (filetype)",
      },
      {
        "<leader>fo",
        builtin("oldfiles"),
        desc = "Telescope recent files",
      },
      {
        "<leader>fb",
        builtin("buffers"),
        desc = "Telescope buffers",
      },
      {
        "<leader>fh",
        builtin("help_tags"),
        desc = "Telescope help tags",
      },
      {
        "<leader>fs",
        builtin("lsp_document_symbols"),
        desc = "Document symbols",
      },
      {
        "<leader>fS",
        builtin("lsp_dynamic_workspace_symbols"),
        desc = "Workspace symbols",
      },
    },
    config = cfg("telescope"),
  },

  -- Icons
  { "nvim-tree/nvim-web-devicons", lazy = true },

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
  {
    "saghen/blink.cmp",
    build = "cargo build --release",
    event = "InsertEnter",
    dependencies = {
      { "saghen/blink.compat", version = "*", opts = {} },
      "rcarriga/cmp-dap",
      "rafamadriz/friendly-snippets",
    },
    config = cfg("blink"),
    version = "1.*",
  },

  -- File browser
  {
    "stevearc/oil.nvim",
    lazy = false,
    dependencies = { "refractalize/oil-git-status.nvim" },
    config = function()
      require("oil").setup({
        win_options = { signcolumn = "yes:3" },
      })
      require("oil-git-status").setup()
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
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({})
    end,
  },

  -- Surround: add/change/delete surrounding pairs (cs"' ds( ysiw))
  {
    "kylechui/nvim-surround",
    event = "BufReadPost",
    config = function()
      require("nvim-surround").setup({})
    end,
  },

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
  { "mechatroner/rainbow_csv", ft = { "csv", "tsv" } },

  -- Keybind popup
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = cfg("which_key"),
  },

  -- Keycaster overlay: shows pressed keys in a floating box (screencast style)
  {
    "nvzone/showkeys",
    dependencies = { "nvzone/volt" },
    event = "VeryLazy",
    opts = {
      timeout = 3, -- seconds each key stays visible
      maxkeys = 5,
      show_count = true,
    },
    config = function(_, opts)
      require("showkeys").setup(opts)
      require("showkeys").toggle()
    end,
  },

  -- Jump anywhere on screen with 2 chars + a label; supercharges f/t/search
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      { "gs", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "gS", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },
  },

  -- Motion hints: shows which motions get you where, right in the buffer
  {
    "tris203/precognition.nvim",
    event = "VeryLazy",
    opts = {},
  },

  -- Practice game for vim motions: run :VimBeGood
  {
    "ThePrimeagen/vim-be-good",
    cmd = "VimBeGood",
    config = function()
      -- comfy-line-numbers hides its label column in all 'nofile' buffers
      -- (needed so it doesn't paint over telescope's borders). vim-be-good's
      -- game buffer is also 'nofile', so re-enable comfy labels on the focused
      -- game float. Guard against telescope, whose floats are 'nofile' too and
      -- transiently focused while a picker builds.
      local group = vim.api.nvim_create_augroup("VimBeGoodComfyLabels", { clear = true })
      local function telescope_active()
        for _, w in ipairs(vim.api.nvim_list_wins()) do
          if vim.bo[vim.api.nvim_win_get_buf(w)].filetype:match("^Telescope") then
            return true
          end
        end
        return false
      end
      vim.api.nvim_create_autocmd({ "WinEnter", "BufWinEnter", "InsertLeave" }, {
        group = group,
        callback = function()
          vim.schedule(function()
            local win = vim.api.nvim_get_current_win()
            if not vim.api.nvim_win_is_valid(win) or telescope_active() then
              return
            end
            local buf = vim.api.nvim_win_get_buf(win)
            local floating = vim.api.nvim_win_get_config(win).relative ~= ""
            if floating and vim.bo[buf].buftype == "nofile" and _G.get_label then
              vim.wo[win].numberwidth = 4
              vim.wo[win].statuscolumn = '%=%s%=%{v:virtnum > 0 ? "" : v:lua.get_label(v:lnum, v:relnum)} '
            end
          end)
        end,
      })
    end,
  },

  -- Indentation guide
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "BufReadPost",
    config = function()
      require("ibl").setup()
    end,
  },

  -- Break bad habits: hints better motions and blocks repeated keys
  {
    "m4xshen/hardtime.nvim",
    event = "BufReadPost",
    dependencies = { "MunifTanjim/nui.nvim" },
    keys = { { "<leader>uH", "<cmd>Hardtime toggle<cr>", desc = "Toggle hardtime" } },
    config = function()
      require("hardtime").setup({})
    end,
  },

  -- Diff views
  { "sindrets/diffview.nvim", cmd = { "DiffviewOpen", "DiffviewClose" } },

  -- Git UI
  { "NeogitOrg/neogit", cmd = { "Neogit" } },

  -- Better fold
  {
    "kevinhwang91/nvim-ufo",
    event = "BufReadPost",
    dependencies = { "kevinhwang91/promise-async" },
    config = cfg("ufo"),
  },

  -- View all LSP errors at once
  { "folke/trouble.nvim", cmd = "Trouble", config = cfg("trouble") },

  -- Visualize undo history
  { "mbbill/undotree", cmd = "UndotreeToggle" },

  -- LSP messages
  {
    "rcarriga/nvim-notify",
    lazy = false,
    config = cfg("notify"),
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
          search = venv_dir
              and {
                shared = { command = "$FD '/bin/python$' " .. venv_dir .. " --full-path --color never" },
              }
            or nil,
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

  -- Relative line numbers using only left-hand digits for comfier vertical motion
  {
    "mluders/comfy-line-numbers.nvim",
    event = "BufReadPost",
    config = function()
      require("comfy-line-numbers").setup({
        -- Keep the default 'nofile' hidden (telescope's border/results/preview
        -- windows are 'nofile'; showing the label column there paints over the
        -- borders) and add 'prompt' (telescope's prompt window). vim-be-good's
        -- game buffer is also 'nofile', so its labels are re-enabled by an
        -- autocmd in the vim-be-good plugin spec.
        hidden_buffer_types = { "terminal", "nofile", "prompt" },
      })
    end,
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
