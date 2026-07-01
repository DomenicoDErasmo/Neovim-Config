local capabilities = require("blink.cmp").get_lsp_capabilities()

-- Path comes from $NVIM_TY (set in ~/.config/shell/shell_settings.sh);
-- falls back to a PATH lookup if the env var is unset.
local ty = os.getenv("NVIM_TY") or "ty"

vim.lsp.config("ty", {
  cmd = { ty, "server" },
  filetypes = { "python" },
  -- ty.toml anchors to the repo root; .git is the fallback.
  -- pyproject.toml is intentionally excluded — it exists in many
  -- subdirectories and would anchor ty to the wrong directory.
  root_markers = { "ty.toml", ".git" },
  capabilities = capabilities,
})

vim.lsp.enable("ty")
