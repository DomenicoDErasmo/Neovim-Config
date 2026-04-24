vim.api.nvim_set_hl(0, "TroubleCursorLine", { bg = "#f38ba8" })
vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = "*",
	callback = function()
		vim.api.nvim_set_hl(0, "TroubleCursorLine", { bg = "#f38ba8" })
	end,
})

require("trouble").setup({
	modes = {
		symbols = {
			win = {
				size = math.max(20, vim.o.columns - 88),
				wo = {
					winhighlight = "Normal:TroubleNormal,NormalNC:TroubleNormalNC,EndOfBuffer:TroubleNormal,CursorLine:TroubleCursorLine",
				},
			},
		},
	},
})
