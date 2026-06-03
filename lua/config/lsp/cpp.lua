clangd = "/atl/make/localcoding/bin/clangd"

vim.lsp.config("dev-clangd", {
  cmd = {
    clangd,
  },
  filetypes = { "c", "cpp" },
  root_markers = { ".clangd", ".git" },
})

if vim.fn.executable(clangd) and vim.fn.filereadable(".clangd") then
  vim.lsp.enable('dev-clangd')
end
