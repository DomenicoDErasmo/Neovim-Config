vim.filetype.add({ extension = { conf = "ini" } })

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.o.number = true
vim.o.relativenumber = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.softtabstop = 2
vim.o.expandtab = true
vim.o.termguicolors = true
vim.o.clipboard = "unnamedplus"

vim.o.foldcolumn = "1"
vim.o.textwidth = 0
-- To ensure a space between fold level and relative number
vim.o.statuscolumn = "%s%C %{v:relnum?v:relnum:v:lnum} "

-- Start with everything unfolded
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99

-- Keep cursor a few lines from the bottom of the screen when scrolling
vim.o.scrolloff = 6

-- Set update time for gitsigns and vim-illuminate on cursor hold
vim.o.updatetime = 300

-- Separate sign column from gitsigns/diagnostics
vim.o.signcolumn = "yes"

-- Custom search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Persistent undofile across sessions
vim.o.undofile = true

-- Set colorcolumn, textwidth, and linebreak for markdown files
vim.api.nvim_create_autocmd("FileType", {
	pattern = "markdown",
	callback = function()
		vim.opt_local.colorcolumn = "81"
		vim.opt_local.textwidth = 80
		vim.opt_local.linebreak = true
		vim.opt_local.conceallevel = 2
	end,
})

-- Set colorcolumn for Python files (black formatter uses 88-char line length)
vim.api.nvim_create_autocmd("FileType", {
	pattern = "python",
	callback = function()
		vim.opt_local.colorcolumn = "88"
		vim.opt_local.formatoptions:remove("t")
	end,
})

-- Configure how diagnostics are shown
vim.diagnostic.config({
	virtual_text = { prefix = "●" },
	signs = true,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	float = { border = "rounded" },
})
