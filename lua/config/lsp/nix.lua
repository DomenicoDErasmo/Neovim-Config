require("config.lsp").setup("nixd", {
  cmd = { require("config.paths").nixd },
  filetypes = { "nix" },
  root_markers = { "flake.nix", ".git" },
})
