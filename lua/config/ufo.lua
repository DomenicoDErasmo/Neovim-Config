local ufo = require("ufo")

ufo.setup({
	provider_selector = function()
		return { "treesitter", "indent" }
	end,
})

-- Open/close all folds
vim.keymap.set("n", "zR", ufo.openAllFolds, { desc = "Open all folds" })
vim.keymap.set("n", "zM", ufo.closeAllFolds, { desc = "Close all folds" })

-- Peek folded content, fall back to LSP hover
vim.keymap.set("n", "K", function()
	local winid = ufo.peekFoldedLinesUnderCursor()
	if not winid then vim.lsp.buf.hover() end
end, { desc = "Peek fold or LSP hover" })
