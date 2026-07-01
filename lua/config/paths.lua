return {
  ruff = require("neoconf").get("ruff_path") or vim.fn.exepath("ruff"),
  ruff_stdin_args = { "--stdin-filename", "$FILENAME", "-" },
  ruff_lint_args = { "--quiet", "--no-fix", "--output-format", "json", "--stdin-filename", "$FILENAME", "-" },
  -- `ty check` linter; same binary as the ty LSP server ($NVIM_TY).
  ty = os.getenv("NVIM_TY") or "ty",
}
