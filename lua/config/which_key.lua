require("which-key").setup({})
require("which-key").add({
  { "<leader>f", group = "find" },
  { "<leader>g", group = "git" },
  { "<leader>t", group = "tab" },
  { "<leader>x", group = "diagnostics" },
})
