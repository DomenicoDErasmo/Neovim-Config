local M = {}

-- leetcode.nvim writes each rust problem as a loose .rs file with no
-- Cargo.toml, which rust-analyzer treats as a "detached file" — a project
-- type that doesn't resolve std types (Vec, HashMap, etc.), even with
-- cargo.sysroot/sysrootSrc set. Giving the file a [[bin]] entry in a shared
-- Cargo.toml in the same directory makes it a normal cargo project instead,
-- where std resolution works out of the box.
function M.question_enter(q)
  if q.lang ~= "rust" then
    return
  end

  local file = tostring(q.file)
  local dir = vim.fs.dirname(file)
  local relname = vim.fs.basename(file)
  local cargo_toml = dir .. "/Cargo.toml"

  local lines
  if vim.fn.filereadable(cargo_toml) == 1 then
    lines = vim.fn.readfile(cargo_toml)
  else
    lines = {
      "[package]",
      'name = "leetcode"',
      'version = "0.1.0"',
      'edition = "2021"',
      "",
      "[workspace]",
    }
  end

  local marker = ('path = "%s"'):format(relname)
  if vim.list_contains(lines, marker) then
    return
  end

  local bin_name = "q" .. relname:gsub("%.rs$", ""):gsub("[^%w]+", "_")
  vim.list_extend(lines, { "", "[[bin]]", ('name = "%s"'):format(bin_name), marker })
  vim.fn.writefile(lines, cargo_toml)
end

return M
