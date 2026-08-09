local clangd = require("config.paths").clangd

if vim.fn.executable(clangd) == 1 then
  require("config.lsp").setup("dev-clangd", {
    cmd = { clangd },
    filetypes = { "c", "cpp" },
    -- Falls back to the buffer's own directory (single-file mode) when
    -- neither marker is found, e.g. for leetcode.nvim's problem files,
    -- which live outside any git repo.
    root_dir = function(bufnr, on_dir)
      local root = vim.fs.root(bufnr, { ".clangd", ".git" })
      on_dir(root or vim.fs.dirname(vim.api.nvim_buf_get_name(bufnr)))
    end,
  })
end
