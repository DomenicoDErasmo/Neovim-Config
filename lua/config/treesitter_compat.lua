-- nvim-treesitter's `master` branch is frozen (upstream moved to `main`,
-- which requires Neovim 0.12+) and its query directives in
-- query_predicates.lua assume each capture in `match` is a single TSNode.
-- Recent Neovim nightlies can hand back a list of nodes instead, which
-- crashes get_node_text -> get_range ("attempt to call method 'range' (a
-- nil value)") when resolving markdown code-fence / HTML <script>
-- injection languages. Re-register the affected directives with a node-or-
-- list-tolerant unwrap so this works on both nightly and stable Neovim.
local query = vim.treesitter.query

local html_script_type_languages = {
  ["importmap"] = "json",
  ["module"] = "javascript",
  ["application/ecmascript"] = "javascript",
  ["text/ecmascript"] = "javascript",
}

local non_filetype_match_injection_language_aliases = {
  ex = "elixir",
  pl = "perl",
  sh = "bash",
  uxn = "uxntal",
  ts = "typescript",
}

local function get_parser_from_markdown_info_string(injection_alias)
  local match = vim.filetype.match({ filename = "a." .. injection_alias })
  return match or non_filetype_match_injection_language_aliases[injection_alias] or injection_alias
end

local function unwrap(node)
  if type(node) == "table" then
    return node[#node]
  end
  return node
end

query.add_directive("set-lang-from-mimetype!", function(match, _, bufnr, pred, metadata)
  local node = unwrap(match[pred[2]])
  if not node then
    return
  end
  local type_attr_value = vim.treesitter.get_node_text(node, bufnr)
  local configured = html_script_type_languages[type_attr_value]
  if configured then
    metadata["injection.language"] = configured
  else
    local parts = vim.split(type_attr_value, "/", {})
    metadata["injection.language"] = parts[#parts]
  end
end, { force = true })

query.add_directive("set-lang-from-info-string!", function(match, _, bufnr, pred, metadata)
  local node = unwrap(match[pred[2]])
  if not node then
    return
  end
  local injection_alias = vim.treesitter.get_node_text(node, bufnr):lower()
  metadata["injection.language"] = get_parser_from_markdown_info_string(injection_alias)
end, { force = true })

query.add_directive("downcase!", function(match, _, bufnr, pred, metadata)
  local id = pred[2]
  local node = unwrap(match[id])
  if not node then
    return
  end
  local text = vim.treesitter.get_node_text(node, bufnr, { metadata = metadata[id] }) or ""
  if not metadata[id] then
    metadata[id] = {}
  end
  metadata[id].text = string.lower(text)
end, { force = true })
