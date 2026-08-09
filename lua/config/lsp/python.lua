-- Path comes from $NVIM_TY (via config.paths); falls back to a PATH lookup.
local ty = require("config.paths").ty

require("config.lsp").setup("ty", {
  cmd = { ty, "server" },
  filetypes = { "python" },
  -- ty.toml anchors to the repo root; .git is the fallback.
  -- pyproject.toml is intentionally excluded — it exists in many
  -- subdirectories and would anchor ty to the wrong directory.
  --
  -- Falls back to the buffer's own directory (single-file mode) when
  -- neither marker is found, e.g. for leetcode.nvim's problem files,
  -- which live outside any git repo.
  root_dir = function(bufnr, on_dir)
    local root = vim.fs.root(bufnr, { "ty.toml", ".git" })
    on_dir(root or vim.fs.dirname(vim.api.nvim_buf_get_name(bufnr)))
  end,
})
