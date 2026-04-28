local workspaces = {
  { name = "notes", path = "~/notes/" },
}

require("obsidian").setup({
  workspaces = workspaces,

  ui = { enable = false },

  -- Use the title as the filename instead of auto-generated ID
  note_id_func = function(title)
    -- If title is provided, use it as the filename
    if title ~= nil then
      return title
    else
      -- Fallback: use timestamp if no title provided
      return tostring(os.time())
    end
  end,

  legacy_commands = false,
})
