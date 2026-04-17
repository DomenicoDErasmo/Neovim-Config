local notify = require("notify")

notify.setup({
  render = "compact",
  background_colour = "#000000",
})

vim.notify = notify

-- Suppress -32802 (ContentModified): fired when ty LSP cancels a request
-- because the document changed mid-flight.
local _notify = vim.notify
vim.notify = function(msg, level, opts)
  if type(msg) == "string" and msg:find("-32802", 1, true) then
    return
  end
  _notify(msg, level, opts)
end
