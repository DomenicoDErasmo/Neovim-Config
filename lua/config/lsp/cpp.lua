-- Path comes from $NVIM_CLANGD (set in ~/.config/shell/shell_settings.sh);
-- falls back to a PATH lookup if the env var is unset.
local clangd = os.getenv("NVIM_CLANGD") or "clangd"

vim.lsp.config("dev-clangd", {
  cmd = {
    clangd,
  },
  filetypes = { "c", "cpp" },
  root_markers = { ".clangd", ".git" },
})

if vim.fn.executable(clangd) == 1 and vim.fn.filereadable(".clangd") == 1 then
  vim.lsp.enable('dev-clangd')
end
