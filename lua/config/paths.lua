return {
  ruff = require("neoconf").get("ruff_path") or vim.fn.exepath("ruff"),
  ruff_args = { "--force-exclude", "--stdin-filename", "$FILENAME", "-" },
}
