-- Path comes from $NVIM_TY (via config.paths); falls back to a PATH lookup.
local ty = require("config.paths").ty

require("config.lsp").setup("ty", {
  cmd = { ty, "server" },
  filetypes = { "python" },
  -- ty.toml anchors to the repo root; .git is the fallback.
  -- pyproject.toml is intentionally excluded — it exists in many
  -- subdirectories and would anchor ty to the wrong directory.
  root_markers = { "ty.toml", ".git" },
})
