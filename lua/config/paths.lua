-- Resolve a tool path: prefer the $env override, else fall back to a
-- PATH lookup.
local function resolve_path(env, default)
  return os.getenv(env) or vim.fn.exepath(default)
end

return {
  clangd = resolve_path("NVIM_CLANGD", "clangd"),
  lua_ls = resolve_path("NVIM_LUA_LS", "lua-language-server"),
  nixd = resolve_path("NVIM_NIXD", "nixd"),
  rust_analyzer = resolve_path("NVIM_RUST_ANALYZER", "rust-analyzer"),
  -- Rust standard library source and compiled sysroot, for rust-analyzer's
  -- sysrootSrc/sysroot settings. No PATH-lookup fallback since these are
  -- directories, not executables.
  rust_src = os.getenv("NVIM_RUST_SRC"),
  rust_sysroot = os.getenv("NVIM_RUST_SYSROOT"),
  ruff = require("neoconf").get("ruff_path") or vim.fn.exepath("ruff"),
  ruff_stdin_args = { "--stdin-filename", "$FILENAME", "-" },
  ruff_lint_args = { "--quiet", "--no-fix", "--output-format", "json", "--stdin-filename", "$FILENAME", "-" },
  -- `ty check` linter; same binary as the ty LSP server ($NVIM_TY).
  ty = os.getenv("NVIM_TY") or "ty",
}
