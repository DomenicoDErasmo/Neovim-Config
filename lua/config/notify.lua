local notify = require("notify")

notify.setup({
  render = "compact",
  background_colour = "#000000",
})

vim.notify = notify
