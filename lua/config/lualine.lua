require("lualine").setup({
  options = { theme = "vscode" },
  sections = {
    lualine_b = { "branch", "diff", "diagnostics" },
    lualine_c = { { "filename", path = 1 } },
    lualine_x = {
      { "searchcount" },
      {
        function()
          local names = vim.iter(vim.lsp.get_clients({ bufnr = 0 })):map(function(c)
            return c.name
          end)
          return names:peek() and " " .. names:join(" ") or ""
        end,
      },
      { vim.lsp.status },
      "encoding",
      "fileformat",
      "filetype",
    },
  },
})
