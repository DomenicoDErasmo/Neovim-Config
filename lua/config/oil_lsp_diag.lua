-- Lightweight LSP diagnostic signs in Oil buffers.
-- Only inspects already-loaded buffers — no filesystem walk, no LSP queries
-- triggered by Oil itself. Files you haven't opened won't get signs.

local M = {}

local ns = vim.api.nvim_create_namespace("oil_lsp_diag")

local sev_hl = {
  [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
  [vim.diagnostic.severity.WARN]  = "DiagnosticSignWarn",
  [vim.diagnostic.severity.INFO]  = "DiagnosticSignInfo",
  [vim.diagnostic.severity.HINT]  = "DiagnosticSignHint",
}
local sev_text = {
  [vim.diagnostic.severity.ERROR] = "E",
  [vim.diagnostic.severity.WARN]  = "W",
  [vim.diagnostic.severity.INFO]  = "I",
  [vim.diagnostic.severity.HINT]  = "H",
}

local function refresh(bufnr)
  if not vim.api.nvim_buf_is_valid(bufnr) then return end
  if vim.bo[bufnr].filetype ~= "oil" then return end
  vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)

  local oil = require("oil")
  local dir = oil.get_current_dir(bufnr)
  if not dir then return end

  -- Worst diagnostic per direct-child filename, from loaded buffers only.
  local worst = {}
  for _, b in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(b) then
      local path = vim.api.nvim_buf_get_name(b)
      if #path > #dir and path:sub(1, #dir) == dir then
        local rel = path:sub(#dir + 1)
        if not rel:find("/") then
          for _, d in ipairs(vim.diagnostic.get(b)) do
            if not worst[rel] or d.severity < worst[rel] then
              worst[rel] = d.severity
            end
          end
        end
      end
    end
  end
  if next(worst) == nil then return end

  for lnum = 1, vim.api.nvim_buf_line_count(bufnr) do
    local entry = oil.get_entry_on_line(bufnr, lnum)
    if entry and worst[entry.name] then
      local sev = worst[entry.name]
      vim.api.nvim_buf_set_extmark(bufnr, ns, lnum - 1, 0, {
        sign_text = sev_text[sev],
        sign_hl_group = sev_hl[sev],
        priority = 10,
      })
    end
  end
end

local group = vim.api.nvim_create_augroup("OilLspDiag", { clear = true })

-- Oil fires this after rendering a directory.
vim.api.nvim_create_autocmd("User", {
  group = group,
  pattern = "OilEnter",
  callback = function(args) refresh(args.buf) end,
})

-- Refresh when diagnostics change in any buffer.
vim.api.nvim_create_autocmd("DiagnosticChanged", {
  group = group,
  callback = function()
    for _, b in ipairs(vim.api.nvim_list_bufs()) do
      if vim.bo[b].filetype == "oil" then refresh(b) end
    end
  end,
})

return M
