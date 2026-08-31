local M = {}

-- Register and enable an LSP server, merging blink.cmp's completion
-- capabilities into whatever the server config provides.
function M.setup(name, cfg)
  cfg.capabilities = vim.tbl_deep_extend("force", require("blink.cmp").get_lsp_capabilities(), cfg.capabilities or {})
  vim.lsp.config(name, cfg)
  vim.lsp.enable(name)
end

-- A `root_dir` resolver that falls back to the buffer's own directory
-- (single-file mode) when no marker is found, e.g. for leetcode.nvim's
-- problem files, which live outside any repo.
function M.root_or_file(markers)
  return function(bufnr, on_dir)
    on_dir(vim.fs.root(bufnr, markers) or vim.fs.dirname(vim.api.nvim_buf_get_name(bufnr)))
  end
end

return M
