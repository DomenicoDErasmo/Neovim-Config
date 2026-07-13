local M = {}

-- Register and enable an LSP server, merging blink.cmp's completion
-- capabilities into whatever the server config provides.
function M.setup(name, cfg)
  cfg.capabilities = vim.tbl_deep_extend(
    "force",
    require("blink.cmp").get_lsp_capabilities(),
    cfg.capabilities or {}
  )
  vim.lsp.config(name, cfg)
  vim.lsp.enable(name)
end

return M
