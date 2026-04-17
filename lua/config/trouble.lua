require("trouble").setup({
	modes = {
		symbols = {
			win = {
				size = math.max(20, vim.o.columns - 88),
			},
		},
	},
})
