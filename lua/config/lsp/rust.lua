require("config.lsp").setup("rust_analyzer", {
  cmd = { require("config.paths").rust_analyzer },
  filetypes = { "rust" },
  root_dir = require("config.lsp").root_or_file({ "Cargo.toml", "rust-project.json" }),
  settings = {
    ["rust-analyzer"] = {
      cargo = {
        allFeatures = true,
        sysroot = require("config.paths").rust_sysroot,
        sysrootSrc = require("config.paths").rust_src,
      },
      checkOnSave = true,
      rustfmt = { overrideCommand = { "rustfmt" } },
      check = {
        command = "clippy",
      },
    },
  },
})
