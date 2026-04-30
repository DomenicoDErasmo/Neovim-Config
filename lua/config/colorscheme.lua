local c = require("vscode.colors").get_colors()
require("vscode").setup({
	-- Enable transparent background
	transparent = true,

	-- Enable italic comment
	italic_comments = true,

	-- Enable italic inlay type hints
	italic_inlayhints = true,

	-- Underline `@markup.link.*` variants
	underline_links = true,

	-- Apply theme colors to terminal
	terminal_colors = true,

	-- Override colors (see ./lua/vscode/colors.lua)
	color_overrides = {
		vscLineNumber = "#FFFFFF",
	},

	-- Override highlight groups (see ./lua/vscode/theme.lua)
	group_overrides = {
		-- this supports the same val table as vim.api.nvim_set_hl
		-- use colors from this colorscheme by requiring vscode.colors!
		Cursor = { fg = c.vscDarkBlue, bg = c.vscLightGreen, bold = true },
		ColorColumn = { bg = "#636363" },
		-- Fix Python kwarg names to VSCode's light blue (#9CDCFE)
		["@variable.parameter"] = { fg = c.vscLightBlue },
		-- Fix Python builtins (None/True/False) to VSCode's light blue (#569CD6)
		["@lsp.type.builtinConstant.python"] = { fg = c.vscBlue },
		["@lsp.type.builtinType.python"] = { fg = c.vscBlue },
		["@lsp.type.keyword.python"] = { fg = c.vscBlue },
		pythonBuiltin = { fg = c.vscBlue },
		-- Fix Python self/cls to VSCode's blue (#569CD6)
		["@variable.builtin"] = { fg = c.vscBlue },
		["@lsp.type.selfParameter.python"] = { fg = c.vscBlue },
		-- trouble.nvim cursor line in symbols panel
		TroubleCursorLine = { bg = "#f38ba8" },
		-- render-markdown.nvim inline code
		MarkdownInlineCode = { fg = c.vscOrange, bg = "NONE" },
	},
})

-- load the theme without affecting devicon colors.
vim.cmd.colorscheme("vscode")
