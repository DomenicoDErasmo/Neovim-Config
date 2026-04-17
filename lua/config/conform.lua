local paths = require("config.paths")

require("conform").setup({
  formatters = {
    stylua = {
      command = vim.fn.exepath("stylua"),
    },
    prettier = {
      command = vim.fn.exepath("prettier"),
      prepend_args = { "--prose-wrap", "always", "--print-width", "80" },
    },
    ruff_fix = {
      command = paths.ruff,
      args = vim.list_extend({ "check", "--fix" }, paths.ruff_stdin_args),
      stdin = true,
      exit_codes = { 0, 1 },
    },
    ruff_format = {
      command = paths.ruff,
      args = vim.list_extend({ "format" }, paths.ruff_stdin_args),
      stdin = true,
    },
  },
  formatters_by_ft = {
    lua = { "stylua" },
    markdown = { "prettier" },
    python = { "ruff_fix", "ruff_format" },
    cpp = { "clang-format" },
    proto = { "buf" },
  },
  format_on_save = {
    timeout_ms = 1000,
    lsp_format = "fallback",
  },
})

vim.api.nvim_create_user_command("Format", function(args)
  local range = nil
  if args.count ~= -1 then
    local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
    range = {
      start = { args.line1, 0 },
      ["end"] = { args.line2, end_line:len() },
    }
  end
  require("conform").format({ async = true, lsp_format = "fallback", range = range })
end, { range = true })
