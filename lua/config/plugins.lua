return {
	-- LSP
	{
		"neovim/nvim-lspconfig",
		event = "BufReadPre",
		dependencies = { "folke/neoconf.nvim" },
		config = function()
			require("neoconf").setup({})
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
	{
		"mfussenegger/nvim-lint",
		ft = { "markdown", "python" },
		config = function()
			require(
				"config.nvim_lint")
		end,
	},

	-- Fuzzy file search
	{ "nvim-telescope/telescope.nvim", },
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
		event = "BufReadPost",
		config = function()
			require("config.treesitter")
		end,
	},

	-- Colorscheme
	{ "Mofiqul/vscode.nvim",    lazy = false,                                               priority = 1000 },

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
	{ "stevearc/oil.nvim",      config = function() require("oil").setup({}) end },

	-- Terminal in Vim window
	{ "akinsho/toggleterm.nvim" },

	-- Autopairs
	{ "windwp/nvim-autopairs",  config = function() require("nvim-autopairs").setup({}) end },

	-- Rainbow delimiters
	-- Pinned because errors throw when I insert certain text
	-- Checked as of 2026-04-14
	{
		"HiPhish/rainbow-delimiters.nvim",
		event = "BufReadPost",
		config = function()
			require("config.rainbow_delimiters")
		end
	},

	-- Obsidian
	{
		"obsidian-nvim/obsidian.nvim",
		ft = "markdown",
		config = function()
			require("config.obsidian")
		end,
	},

	-- Markdown rendering
	{
		"MeanderingProgrammer/render-markdown.nvim",
		ft = { "markdown" },
		config = function()
			require("config.render_markdown")
		end,
	},

	-- Rainbow CSV
	{ "mechatroner/rainbow_csv" },

	-- Keybind popup
	{ "folke/which-key.nvim",                event = "VeryLazy" },

	-- Indentation guide
	{ "lukas-reineke/indent-blankline.nvim", config = function() require("ibl").setup() end },

	-- Diff views
	{ "sindrets/diffview.nvim",              cmd = { "DiffviewOpen", "DiffviewClose" } },

	-- Git UI
	{ "NeogitOrg/neogit",                    cmd = { "Neogit" } },

	-- Better fold
	{ "kevinhwang91/nvim-ufo",               dependencies = { "kevinhwang91/promise-async" } },

	-- View all LSP errors at once
	{ "folke/trouble.nvim",                  config = function() require("config.trouble") end },

	-- Visualize undo history
	{ "mbbill/undotree",                     cmd = "UndotreeToggle" },

	-- LSP messages
	{ "rcarriga/nvim-notify", },
}
