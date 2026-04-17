require("nvim-treesitter").setup({
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
	},
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
	indent = {
		enable = true,
	},
})
