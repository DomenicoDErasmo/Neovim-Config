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
  completion = {
    documentation = { auto_show = true, auto_show_delay_ms = 200 },
    ghost_text = { enabled = true },
  },
  sources = {
    default = { "lsp", "path", "buffer", "snippets" },
    per_filetype = {
      markdown = { "lsp", "path", "snippets" },
    },
  },
  signature = { enabled = true, window = { show_documentation = true, } },
})
