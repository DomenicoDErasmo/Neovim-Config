local lint = require("lint")
local paths = require("config.paths")

lint.linters["markdownlint-cli2"].cmd = paths.markdownlint
lint.linters["ruff"].cmd = paths.ruff

-- Walk up from `start`'s directory looking for any of `names`.
-- Returns the config's path and its containing directory, or nil.
local function find_upward(names, start)
  if start == "" then
    return nil
  end
  local found = vim.fs.find(names, { upward = true, path = vim.fs.dirname(start) })[1]
  if found then
    return found, vim.fs.dirname(found)
  end
end

-- we have different configs in OTL and DEV
local function ruff_args_for_buf()
  local config, config_dir = find_upward({ "ruff.toml", ".ruff.toml" }, vim.api.nvim_buf_get_name(0))
  -- ruff resolves `src = ["."]` against cwd, so chdir to the config's
  -- directory before invoking, otherwise first-party detection breaks
  lint.linters["ruff"].cwd = config_dir
  local args = vim.deepcopy(paths.ruff_lint_args)
  if config then
    vim.list_extend(args, { "--config", config })
  end
  return vim.list_extend({ "check" }, args)
end

-- ty's LSP server (v0.0.x) doesn't publish diagnostics, only navigation.
-- Run `ty check` as a linter to surface unresolved-import and other errors.
local ty_severities = {
  error = vim.diagnostic.severity.ERROR,
  warning = vim.diagnostic.severity.WARN,
  info = vim.diagnostic.severity.INFO,
}

local ty_base_args = { "check", "--output-format", "concise" }

lint.linters["ty"] = {
  cmd = paths.ty,
  stdin = false,
  stream = "stdout",
  ignore_exitcode = true,
  args = ty_base_args,
  -- append the buffer's path so ty checks the file we're editing
  parser = require("lint.parser").from_pattern(
    "([^:]+):(%d+):(%d+): (%a+)%[([%w-]+)%] (.*)",
    { "file", "lnum", "col", "severity", "code", "message" },
    ty_severities,
    { ["source"] = "ty" }
  ),
}

-- locate the directory containing the nearest ty.toml so ty picks up
-- the right config (rDEV has separate configs in / and otl/)
local function ty_cwd_for_buf()
  local _, config_dir = find_upward({ "ty.toml" }, vim.api.nvim_buf_get_name(0))
  return config_dir
end

-- Only markdown is dispatched through `try_lint()` with no name; the python
-- linters are invoked explicitly below.
lint.linters_by_ft = {
  markdown = { "markdownlint-cli2" },
}

vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "InsertLeave" }, {
  callback = function(args)
    local ft = vim.bo.filetype
    if ft == "python" then
      -- ruff isn't always on $PATH (only pulled in by project-local direnv
      -- shells); an empty cmd makes nvim-lint spawn "" and throw ENOENT
      if lint.linters["ruff"].cmd ~= "" then
        lint.linters["ruff"].args = ruff_args_for_buf()
        lint.try_lint("ruff")
      end
      -- ty is slower (~2s/file) so skip it on InsertLeave
      if args.event ~= "InsertLeave" then
        local cwd = ty_cwd_for_buf()
        if cwd then
          lint.linters["ty"].cwd = cwd
          -- copy so we don't mutate the shared base list
          lint.linters["ty"].args = vim.list_extend(vim.deepcopy(ty_base_args), { vim.api.nvim_buf_get_name(0) })
          lint.try_lint("ty")
        end
      end
    elseif ft == "markdown" then
      lint.try_lint()
    end
  end,
})
