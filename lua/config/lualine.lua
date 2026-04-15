require("lualine").setup({
  options = { theme = "vscode" },
  sections = {
    lualine_c = { { "filename", path = 1 } }, -- show relative path
  },
})
