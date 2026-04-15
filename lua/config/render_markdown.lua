local c = require("vscode.colors").get_colors()
vim.api.nvim_set_hl(0, "MarkdownInlineCode", { fg = c.vscOrange, bg = "NONE" })

require("render-markdown").setup({
	code = {
		disable_background = true,
		highlight_inline = "MarkdownInlineCode",
	},
})
