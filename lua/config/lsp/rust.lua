require("config.lsp").setup("rust_analyzer", {
  cmd = { require("config.paths").rust_analyzer },
  filetypes = { "rust" },
  -- Falls back to the buffer's own directory (single-file mode) when
  -- neither marker is found, e.g. for leetcode.nvim's problem files,
  -- which live outside any cargo project.
  root_dir = function(bufnr, on_dir)
    local root = vim.fs.root(bufnr, { "Cargo.toml", "rust-project.json" })
    on_dir(root or vim.fs.dirname(vim.api.nvim_buf_get_name(bufnr)))
  end,
  settings = {
    ["rust-analyzer"] = {
      cargo = { allFeatures = true, sysrootSrc = require("config.paths").rust_src },
      checkOnSave = true,
      rustfmt = { overrideCommand = { "rustfmt" } },
      check = {
        command = "clippy",
      },
    },
  },
})
