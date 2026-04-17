local lint = require("lint")
local paths = require("config.paths")

local home = os.getenv("HOME")

lint.linters["markdownlint-cli2"].cmd = home .. "/node_modules/.bin/markdownlint-cli2"

lint.linters["ruff"].cmd = paths.ruff
lint.linters["ruff"].args = vim.list_extend({ "check" }, paths.ruff_lint_args)

lint.linters_by_ft = {
  markdown = { "markdownlint-cli2" },
  python = { "ruff" },
}

vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "InsertLeave" }, {
  callback = function()
    local ft = vim.bo.filetype
    if ft == "python" or ft == "markdown" then
      lint.try_lint()
    end
  end,
})
