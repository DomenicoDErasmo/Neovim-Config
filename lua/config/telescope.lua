-- Keymaps live in the plugin spec's `keys` table (config.plugins) so telescope
-- lazy-loads on first press. This file only runs once telescope is loaded.
require("telescope").setup({
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
    },
  },
})

require("telescope").load_extension("fzf")
