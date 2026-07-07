vim.lsp.config["rust_analyzer"] = {
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
}

vim.api.nvim_create_autocmd("FileType", {
	pattern = "rust",
	callback = function()
		vim.lsp.start(vim.lsp.config["rust_analyzer"])
	end,
})
