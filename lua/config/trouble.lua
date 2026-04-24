local function set_trouble_hl()
	local ok, palette = pcall(require, "catppuccin.palettes")
	local red = ok and palette.get_palette("mocha").red or "#f38ba8"
	vim.api.nvim_set_hl(0, "TroubleCursorLine", { bg = red })
end

set_trouble_hl()
vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = "*",
	callback = set_trouble_hl,
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
