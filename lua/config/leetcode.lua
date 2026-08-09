require("leetcode").setup({
  lang = "python3",
  hooks = {
    -- Gives rust problem files a shared Cargo.toml so rust-analyzer resolves
    -- std types; see lua/config/leetcode_rust_project.lua for why.
    question_enter = { require("config.leetcode_rust_project").question_enter },
  },
})
