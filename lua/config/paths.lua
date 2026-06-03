return {
  ruff = require("neoconf").get("ruff_path") or vim.fn.exepath("ruff"),
  ruff_stdin_args = { "--stdin-filename", "$FILENAME", "-" },
  ruff_lint_args = { "--quiet", "--no-fix", "--output-format", "json", "--stdin-filename", "$FILENAME", "-" },
  ty = os.getenv("HOME") .. "/.local/bin/ty",
}
