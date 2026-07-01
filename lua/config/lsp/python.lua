local capabilities = require("blink.cmp").get_lsp_capabilities()

vim.lsp.config("ty", {
  cmd = { "/scratch/atl/ty/releases/ty-latest", "server" },
  filetypes = { "python" },
  -- ty.toml anchors to the repo root; .git is the fallback.
  -- pyproject.toml is intentionally excluded — it exists in many
  -- subdirectories and would anchor ty to the wrong directory.
  root_markers = { "ty.toml", ".git" },
  capabilities = capabilities,
})

vim.lsp.enable("ty")
