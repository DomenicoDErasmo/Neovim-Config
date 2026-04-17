local ufo = require("ufo")

ufo.setup({
	provider_selector = function()
		return { "treesitter", "indent" }
	end,
})

-- Open/close all folds
vim.keymap.set("n", "zR", ufo.openAllFolds, { desc = "Open all folds" })
vim.keymap.set("n", "zM", ufo.closeAllFolds, { desc = "Close all folds" })
