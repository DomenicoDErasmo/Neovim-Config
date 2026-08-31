local dap = require("dap")
local dapui = require("dapui")

-- Python interpreter that has debugpy installed (pip install debugpy).
-- Set $NVIM_DEBUGPY_PYTHON to a specific venv; falls back to python3 on PATH.
require("dap-python").setup(os.getenv("NVIM_DEBUGPY_PYTHON") or "python3")

dapui.setup({
  layouts = {
    {
      elements = {
        { id = "scopes", size = 0.35 },
        { id = "watches", size = 0.25 },
        { id = "stacks", size = 0.25 },
        { id = "breakpoints", size = 0.15 },
      },
      size = 50, -- sidebar width in columns (default 40)
      position = "left",
    },
    {
      elements = {
        { id = "repl", size = 0.6 }, -- give the repl more room than console
        { id = "console", size = 0.4 },
      },
      size = 15, -- bottom tray height in rows (default 10)
      position = "bottom",
    },
  },
})
require("nvim-dap-virtual-text").setup()

-- VSCode-style gutter icons: name -> { glyph, fg, linehl }
for name, sign in pairs({
  DapBreakpoint = { "●", "#e51400" },
  DapBreakpointCondition = { "◐", "#e51400" },
  DapBreakpointRejected = { "●", "#888888" },
  DapLogPoint = { "◆", "#61afef" },
  DapStopped = { "▶", "#ffcc00", linehl = "DapStoppedLine" },
}) do
  vim.fn.sign_define(name, { text = sign[1], texthl = name, linehl = sign.linehl or "", numhl = "" })
  vim.api.nvim_set_hl(0, name, { fg = sign[2] })
end
vim.api.nvim_set_hl(0, "DapStoppedLine", { bg = "#2e2d2d" })

-- Auto open/close UI with debug sessions
for _, event in ipairs({ "attach", "launch" }) do
  dap.listeners.before[event].dapui_config = function()
    dapui.open()
  end
end
for _, event in ipairs({ "event_terminated", "event_exited" }) do
  dap.listeners.before[event].dapui_config = function()
    dapui.close()
  end
end

local map = vim.keymap.set
map("n", "<leader>dc", dap.continue, { desc = "Continue / start" })
map("n", "<leader>da", function()
  dap.run({
    type = "python",
    request = "launch",
    name = "Launch with args",
    program = "${file}",
    console = "integratedTerminal",
    args = function()
      return vim.split(vim.fn.input("Args: "), " ", { trimempty = true })
    end,
  })
end, { desc = "Launch with args" })
map("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
map("n", "<leader>dB", function()
  dap.set_breakpoint(vim.fn.input("Condition: "))
end, { desc = "Conditional breakpoint" })
map("n", "<leader>di", dap.step_into, { desc = "Step into" })
map("n", "<leader>do", dap.step_over, { desc = "Step over" })
map("n", "<leader>dO", dap.step_out, { desc = "Step out" })
map("n", "<leader>dt", dap.terminate, { desc = "Terminate" })
map("n", "<leader>du", dapui.toggle, { desc = "Toggle DAP UI" })
map("n", "<leader>dr", dap.repl.open, { desc = "Open REPL" })
map("n", "<leader>d=", "<cmd>resize +5<cr>", { desc = "DAP window taller" })
map("n", "<leader>d-", "<cmd>resize -5<cr>", { desc = "DAP window shorter" })
map("n", "<leader>d>", "<cmd>vertical resize +5<cr>", { desc = "DAP window wider" })
map("n", "<leader>d<", "<cmd>vertical resize -5<cr>", { desc = "DAP window narrower" })
map("n", "<leader>dm", function()
  require("dap-python").test_method()
end, { desc = "Debug test method" })
map("n", "<leader>dM", function()
  require("dap-python").test_class()
end, { desc = "Debug test class" })
