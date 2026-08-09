require("leetcode").setup({
  lang = "python3",
  hooks = {
    -- Gives rust problem files a shared Cargo.toml so rust-analyzer resolves
    -- std types; see lua/config/leetcode_rust_project.lua for why.
    question_enter = { require("config.leetcode_rust_project").question_enter },
  },
  injector = {
    -- Injected code is local-only (never submitted/run), so this exists purely to
    -- give rust-analyzer a `Solution` type to resolve `impl Solution` against —
    -- LeetCode's real judge supplies this itself. Without it, `impl Solution`
    -- is an impl on an unknown type and method autocomplete doesn't work.
    rust = { before = "struct Solution;" },
  },
})
