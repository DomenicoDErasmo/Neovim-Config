vim.filetype.add({ extension = { conf = "ini" } })

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.o.number = true
vim.o.relativenumber = true
vim.o.expandtab = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.softtabstop = 2
vim.o.autoindent = true
vim.o.termguicolors = true

vim.o.foldcolumn = "1"
vim.o.foldenable = true
vim.o.textwidth = 0
-- To ensure a space between fold level and relative number
vim.o.statuscolumn = "%C %{v:relnum?v:relnum:v:lnum} "

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
vim.o.hlsearch = true

-- Persistent undofile across sections
vim.o.undofile = true

-- Set colorcolumn, textwidth, and linebreak for markdown files
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt_local.colorcolumn = "81"
    vim.opt_local.textwidth = 80
    vim.opt_local.linebreak = true
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
