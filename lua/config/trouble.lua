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
