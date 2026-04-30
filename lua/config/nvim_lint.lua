local lint = require("lint")
local paths = require("config.paths")

local home = os.getenv("HOME")

lint.linters["markdownlint-cli2"].cmd = home .. "/node_modules/.bin/markdownlint-cli2"

lint.linters["ruff"].cmd = paths.ruff

-- we have different configs in OTL and DEV
local function ruff_args_for_buf()
  local bufname = vim.api.nvim_buf_get_name(0)
  local dir = vim.fn.fnamemodify(bufname, ":h")
  local config, config_dir = nil, nil
  while dir ~= "/" do
    for _, name in ipairs({ "ruff.toml", ".ruff.toml" }) do
      if vim.fn.filereadable(dir .. "/" .. name) == 1 then
        config = dir .. "/" .. name
        config_dir = dir
        break
      end
    end
    if config then
      break
    end
    dir = vim.fn.fnamemodify(dir, ":h")
  end
  -- ruff resolves `src = ["."]` against cwd, so chdir to the config's
  -- directory before invoking, otherwise first-party detection breaks
  lint.linters["ruff"].cwd = config_dir
  local args = vim.deepcopy(paths.ruff_lint_args)
  if config then
    vim.list_extend(args, { "--config", config })
  end
  return vim.list_extend({ "check" }, args)
end

lint.linters_by_ft = {
  markdown = { "markdownlint-cli2" },
  python = { "ruff" },
}

vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "InsertLeave" }, {
  callback = function()
    local ft = vim.bo.filetype
    if ft == "python" then
      lint.linters["ruff"].args = ruff_args_for_buf()
      lint.try_lint()
    elseif ft == "markdown" then
      lint.try_lint()
    end
  end,
})
