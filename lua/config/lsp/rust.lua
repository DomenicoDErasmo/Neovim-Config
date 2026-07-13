require("config.lsp").setup("rust_analyzer", {
	cmd = { vim.fn.exepath("rust-analyzer") },
	filetypes = { "rust" },
	root_markers = { "Cargo.toml", "rust-project.json" },
	settings = {
		["rust-analyzer"] = {
			cargo = { allFeatures = true },
			checkOnSave = true,
			rustfmt = { overrideCommand = { "rustfmt" } },
			check = {
				command = "clippy",
			},
		},
	},
})
