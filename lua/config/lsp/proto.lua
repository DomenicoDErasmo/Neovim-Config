local capabilities = require("blink.cmp").get_lsp_capabilities()

vim.lsp.config("buf_ls", {
	capabilities = capabilities,
	root_markers = { "buf.yaml", "buf.work.yaml", ".git" },
})

vim.lsp.enable("buf_ls")
