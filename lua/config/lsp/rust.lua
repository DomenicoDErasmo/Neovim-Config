vim.lsp.config("rust_analyzer", {
	capabilities = require("blink.cmp").get_lsp_capabilities(),
	cmd = { "rustup", "run", "stable", "rust-analyzer" },
	filetypes = { "rust" },
	root_markers = { "Cargo.toml", "Cargo.lock", ".git" },
	settings = {
		["rust-analyzer"] = {
			checkOnSave = { command = "clippy" },
		},
	},
})

vim.lsp.enable("rust_analyzer")
