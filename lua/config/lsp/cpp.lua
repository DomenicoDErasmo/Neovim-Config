local clangd = require("config.paths").clangd

if vim.fn.executable(clangd) == 1 and vim.fn.filereadable(".clangd") == 1 then
  require("config.lsp").setup("dev-clangd", {
    cmd = { clangd },
    filetypes = { "c", "cpp" },
    root_markers = { ".clangd", ".git" },
  })
end
