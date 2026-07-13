local notify = require("notify")

notify.setup({
  render = "compact",
  background_colour = "#000000",
})

-- Suppress -32802 (ContentModified): fired when ty LSP cancels a request
-- because the document changed mid-flight.
vim.notify = function(msg, level, opts)
  if type(msg) == "string" and msg:find("-32802", 1, true) then
    return
  end
  notify(msg, level, opts)
end
