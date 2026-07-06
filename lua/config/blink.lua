require("blink.cmp").setup({
  snippets = { preset = "default" },
  keymap = {
    preset = "none",
    ["<CR>"] = { "accept", "fallback" },
    ["<Tab>"] = { "select_next", "fallback" },
    ["<S-Tab>"] = { "select_prev", "fallback" },
    ["<C-Space>"] = { "show", "fallback" },
    ["<C-e>"] = { "hide", "fallback" },
    ["<C-d>"] = { "scroll_documentation_up", "fallback" },
    ["<C-f>"] = { "scroll_documentation_down", "fallback" },
  },
  -- Enable completion in DAP prompt buffers (repl/watches/hover), which blink
  -- disables by default because they are `prompt` buftype.
  enabled = function()
    return vim.bo.buftype ~= "prompt" or require("cmp_dap").is_dap_buffer()
  end,
  completion = {
    documentation = { auto_show = true, auto_show_delay_ms = 200 },
    ghost_text = { enabled = true },
  },
  sources = {
    default = { "lsp", "path", "buffer", "snippets" },
    per_filetype = {
      markdown = { "lsp", "path", "snippets" },
      ["dap-repl"] = { "dap" },
      dapui_watches = { "dap" },
      dapui_hover = { "dap" },
    },
    providers = {
      dap = { name = "dap", module = "blink.compat.source" },
    },
  },
  signature = { enabled = true, window = { show_documentation = true, } },
})
