local clangd = require("config.paths").clangd

if vim.fn.executable(clangd) == 1 then
  require("config.lsp").setup("dev-clangd", {
    cmd = { clangd },
    filetypes = { "c", "cpp" },
    root_dir = require("config.lsp").root_or_file({ ".clangd", ".git" }),
  })
end
