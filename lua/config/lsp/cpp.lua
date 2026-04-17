local capabilities = require("blink.cmp").get_lsp_capabilities()
capabilities.offsetEncoding = { "utf-16" }

vim.lsp.config("clangd", {
	capabilities = capabilities,
	cmd = {
		"clangd",
		"--background-index",
		"--clang-tidy",
		"--header-insertion=iwyu",
		"--completion-style=detailed",
		"--function-arg-placeholders=true",
	},
	filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
	root_markers = { "compile_commands.json", ".clangd", ".clang-format", ".clang-tidy", ".git" },
})

vim.lsp.enable("clangd")
