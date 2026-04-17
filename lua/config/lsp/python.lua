local capabilities = require("blink.cmp").get_lsp_capabilities()

vim.lsp.config("ty", {
	cmd = { os.getenv("HOME") .. "/.local/bin/ty", "server" },
	filetypes = { "python" },
	-- ty.toml anchors to the repo root; .git is the fallback.
	-- pyproject.toml is intentionally excluded — it exists in many
	-- subdirectories and would anchor ty to the wrong directory.
	root_markers = { "ty.toml", ".git" },
	capabilities = capabilities,
})

vim.lsp.enable("ty")
