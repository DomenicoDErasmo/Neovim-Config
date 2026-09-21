local nixd = require("config.paths").nixd

-- Only use for NixOS
if vim.fn.executable(nixd) == 1 then
  require("config.lsp").setup("nixd", {
    cmd = { nixd },
    filetypes = { "nix" },
    root_markers = { "flake.nix", ".git" },
  })
end
