if vim.fn.has("nvim-0.12") == 0 then
  require("config.treesitter_master")
  return
end

local parsers = {
  "lua",
  "cpp",
  "python",
  "css",
  "cmake",
  "markdown",
  "markdown_inline",
  "nix",
  "bash",
  "ini",
  "yaml",
  "proto",
  "rust",
  "html",
}

-- No-op for parsers that are already installed; runs asynchronously.
require("nvim-treesitter").install(parsers)

-- The `main` branch no longer enables highlighting itself: start Neovim's
-- built-in treesitter highlighter for any buffer whose language has a parser.
-- pcall because most filetypes (oil, help panes, ...) have no parser installed.
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("treesitter_start", { clear = true }),
  callback = function(args)
    pcall(vim.treesitter.start, args.buf)
  end,
})
