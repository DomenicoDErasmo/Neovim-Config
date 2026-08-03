-- Go-to-definition for pytest fixtures.

-- This resolves the name the way pytest does and is wired as a *fallback*
-- under `gd` (see config/keymap.lua): `goto_fixture()` returns true only when
-- it actually jumped, so on any miss `gd` behaves exactly as it did before.

local M = {}

-- Fixtures can't have defaults or be *args/**kwargs, so only these two node
-- types can name one. `typed_parameter` is what makes `tmp_path: Path` work —
-- the annotation is precisely what causes jedi to bail, so it must not
-- disqualify the parameter here.
local PARAM_TYPES = {
  identifier = true,
  typed_parameter = true,
}

local IGNORED_PARAMS = {
  self = true,
  cls = true,
}

-- Root markers match config/lsp/python.lua so navigation and type checking
-- agree on where the project ends. pyproject.toml is deliberately excluded —
-- it exists in many subdirectories and would anchor to the wrong place.
local ROOT_MARKERS = { "ty.toml", ".git" }

-- Parsed conftest/current-file fixture tables, keyed by path. Cleared for a
-- file when it's written; see the BufWritePost autocmd at the bottom.
local fixture_cache = {}

-- Resolved `_pytest` package directory, keyed by interpreter path.
local pytest_dir_cache = {}

local function node_text(node, source)
  return node and vim.treesitter.get_node_text(node, source) or nil
end

-- The name a parameter node binds, or nil if it can't be a fixture.
local function param_name(node, source)
  if not PARAM_TYPES[node:type()] then
    return nil
  end
  -- For `typed_parameter` the name is the first child; `identifier` is itself.
  local name_node = node:type() == "identifier" and node or node:child(0)
  if not name_node or name_node:type() ~= "identifier" then
    return nil
  end
  local name = node_text(name_node, source)
  if not name or IGNORED_PARAMS[name] then
    return nil
  end
  return name
end

-- Every fixture-eligible parameter name of a `function_definition` node.
local function param_names(func, source)
  local names = {}
  local params = func:field("parameters")[1]
  if not params then
    return names
  end
  for child in params:iter_children() do
    local name = param_name(child, source)
    if name then
      names[name] = true
    end
  end
  return names
end

-- The name under the cursor, if it is (or refers to) a fixture-shaped
-- parameter of the enclosing function. Deliberately does NOT require the
-- function to look like a test — that heuristic is why jedi fails here.
local function fixture_name_at_cursor(bufnr)
  local ok, node = pcall(vim.treesitter.get_node, { bufnr = bufnr })
  if not ok or not node or node:type() ~= "identifier" then
    return nil
  end
  local name = node_text(node, bufnr)
  if not name or IGNORED_PARAMS[name] then
    return nil
  end

  local func = node
  while func and func:type() ~= "function_definition" do
    func = func:parent()
  end
  if not func then
    return nil
  end

  -- Either the cursor is on the parameter itself, or on a usage in the body
  -- whose name matches one of the parameters.
  return param_names(func, bufnr)[name] and name or nil
end

-- `@pytest.fixture` / `@fixture` / `@pytest.fixture(scope=...)`, and the
-- `name=` override (`@fixture(name="LineMatcher")`) which renames the fixture.
local function fixture_decorator_name(decorated, source)
  local override
  local found = false
  for child in decorated:iter_children() do
    if child:type() == "decorator" then
      local text = node_text(child, source) or ""
      if text:match("fixture") then
        found = true
        override = override or text:match("name%s*=%s*[\"']([%w_]+)[\"']")
      end
    end
  end
  return found, override
end

-- Map of fixture name -> {row, col} (0-indexed) for one parsed file.
local function fixtures_in(source, path)
  local parser = vim.treesitter.get_string_parser(source, "python")
  if not parser then
    return {}
  end
  local root = parser:parse()[1]:root()
  local found = {}

  local function scan(node)
    for child in node:iter_children() do
      if child:type() == "decorated_definition" then
        local is_fixture, override = fixture_decorator_name(child, source)
        local def = child:field("definition")[1]
        if is_fixture and def and def:type() == "function_definition" then
          local name_node = def:field("name")[1]
          local name = override or node_text(name_node, source)
          if name and not found[name] then
            local row, col = name_node:start()
            found[name] = { path = path, row = row, col = col }
          end
        end
      elseif child:type() == "class_definition" or child:type() == "block" or child:type() == "module" then
        -- Fixtures can live in a class body; recurse through wrappers only.
        scan(child)
      end
    end
  end

  scan(root)
  return found
end

local function fixtures_in_file(path)
  if fixture_cache[path] then
    return fixture_cache[path]
  end
  local ok, lines = pcall(vim.fn.readfile, path)
  if not ok or type(lines) ~= "table" then
    return {}
  end
  local found = fixtures_in(table.concat(lines, "\n"), path)
  fixture_cache[path] = found
  return found
end

-- Directories from the file's own directory up to (and including) the one
-- holding a root marker. Bounded by the project root so we never walk to /.
local function dirs_up_to_root(start_dir)
  local dirs = {}
  local dir = start_dir
  while dir and dir ~= "/" and dir ~= "" do
    table.insert(dirs, dir)
    for _, marker in ipairs(ROOT_MARKERS) do
      local p = dir .. "/" .. marker
      if vim.fn.filereadable(p) == 1 or vim.fn.isdirectory(p) == 1 then
        return dirs
      end
    end
    local parent = vim.fn.fnamemodify(dir, ":h")
    if parent == dir then
      break
    end
    dir = parent
  end
  return dirs
end

-- The interpreter to ask about `_pytest`: the selected venv when there is one
-- (venv-selector is already consulted this way in config/plugins.lua for
-- dap-python), else python3 from PATH.
local function python_interpreter()
  local ok, venv = pcall(require, "venv-selector")
  if ok then
    local python = select(2, pcall(venv.python))
    if type(python) == "string" and python ~= "" then
      return python
    end
  end
  local python3 = vim.fn.exepath("python3")
  return python3 ~= "" and python3 or nil
end

local function pytest_builtin_dir()
  local python = python_interpreter()
  if not python then
    return nil
  end
  local cached = pytest_dir_cache[python]
  if cached ~= nil then
    return cached ~= false and cached or nil
  end

  local out = vim.fn.systemlist({ python, "-c", "import _pytest, os; print(os.path.dirname(_pytest.__file__))" })
  local dir = (vim.v.shell_error == 0 and out[1] and vim.fn.isdirectory(out[1]) == 1) and out[1] or false
  pytest_dir_cache[python] = dir
  return dir ~= false and dir or nil
end

-- Builtin fixtures are spread across _pytest/*.py; grep for a `@fixture`
-- decorated `def <name>` rather than parsing the whole package.
local function find_builtin_fixture(name)
  local dir = pytest_builtin_dir()
  if not dir or vim.fn.executable("rg") == 0 then
    return nil
  end

  local out = vim.fn.systemlist({
    "rg",
    "--no-heading",
    "--line-number",
    "--multiline",
    "--glob",
    "*.py",
    "@fixture[^\\n]*\\n(\\([^)]*\\)\\n)?def " .. name .. "\\b",
    dir,
  })
  if vim.v.shell_error ~= 0 then
    return nil
  end

  for _, line in ipairs(out) do
    -- rg reports the match start (the decorator); the `def` is on a later
    -- line, so scan forward from there for it.
    local path, lnum = line:match("^([^:]+):(%d+):")
    if path and vim.fn.filereadable(path) == 1 then
      local lines = vim.fn.readfile(path)
      for i = tonumber(lnum), math.min(tonumber(lnum) + 4, #lines) do
        local col = lines[i] and lines[i]:find("def " .. name .. "%f[^%w_]")
        if col then
          return { path = path, row = i - 1, col = col + 3 }
        end
      end
    end
  end
  return nil
end

-- Resolve in pytest's own order, first hit wins: the file itself, then each
-- conftest.py walking up to the project root, then the pytest builtins.
local function resolve(name, bufnr)
  local file = vim.api.nvim_buf_get_name(bufnr)
  if file == "" then
    return nil
  end

  local own = fixtures_in(table.concat(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false), "\n"), file)[name]
  if own then
    return own
  end

  for _, dir in ipairs(dirs_up_to_root(vim.fn.fnamemodify(file, ":h"))) do
    local conftest = dir .. "/conftest.py"
    if vim.fn.filereadable(conftest) == 1 then
      local hit = fixtures_in_file(conftest)[name]
      if hit then
        return hit
      end
    end
  end

  return find_builtin_fixture(name)
end

--- Jump to the pytest fixture behind the parameter under the cursor.
--- Returns true only if it jumped, so callers can fall back to the LSP.
function M.goto_fixture()
  local bufnr = vim.api.nvim_get_current_buf()
  if vim.bo[bufnr].filetype ~= "python" then
    return false
  end

  local ok, name = pcall(fixture_name_at_cursor, bufnr)
  if not ok or not name then
    return false
  end

  local found
  ok, found = pcall(resolve, name, bufnr)
  if not ok or not found then
    return false
  end

  -- Push to the tag stack first so Ctrl-o comes back here.
  local from = vim.fn.getpos(".")
  from[1] = bufnr
  vim.fn.settagstack(vim.fn.win_getid(), {
    items = { { tagname = name, from = from } },
  }, "t")

  vim.cmd.edit(vim.fn.fnameescape(found.path))
  vim.api.nvim_win_set_cursor(0, { found.row + 1, found.col })
  vim.cmd("normal! zz")
  return true
end

vim.api.nvim_create_autocmd("BufWritePost", {
  group = vim.api.nvim_create_augroup("PytestFixtureCache", { clear = true }),
  pattern = "*.py",
  callback = function(args)
    fixture_cache[vim.api.nvim_buf_get_name(args.buf)] = nil
  end,
})

return M
