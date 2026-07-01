require("which-key").setup({})
require("which-key").add({
  { "<leader>f", group = "find" },
  { "<leader>g", group = "git" },
  { "<leader>h", group = "hunk" },
  { "<leader>x", group = "diagnostics" },
  { "<leader>c", group = "code" },
  { "<leader>s", group = "swap" },
  { "<leader>t", group = "terminal/tab" },
  { "<leader>r", group = "rename" },
  { "<leader>d", group = "debug" },
  { "<leader>u", group = "ui/toggle" },
})
