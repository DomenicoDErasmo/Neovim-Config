require("obsidian").setup({
  workspaces = {
    { name = "notes", path = "~/notes/" },
  },

  ui = { enable = false },

  -- Use the title as the filename instead of an auto-generated ID.
  note_id_func = function(title)
    return title or tostring(os.time())
  end,

  legacy_commands = false,
})
