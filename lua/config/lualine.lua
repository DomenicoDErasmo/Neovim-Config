require("lualine").setup({
  options = { theme = "vscode" },
  sections = {
    lualine_b = { "branch", "diff", "diagnostics" },
    lualine_c = { { "filename", path = 1 } },
    lualine_x = {
      {
        function()
          local clients = vim.lsp.get_clients({ bufnr = 0 })
          if #clients == 0 then return "" end
          return " " .. table.concat(vim.tbl_map(function(c) return c.name end, clients), " ")
        end,
      },
      "encoding", "fileformat", "filetype",
    },
  },
})
