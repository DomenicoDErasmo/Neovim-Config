require("config.lsp").setup("rust_analyzer", {
	cmd = { require("config.paths").rust_analyzer },
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
