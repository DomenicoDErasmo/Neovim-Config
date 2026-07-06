local dap = require("dap")
local dapui = require("dapui")

-- Python interpreter that has debugpy installed (pip install debugpy).
-- Set $NVIM_DEBUGPY_PYTHON to a specific venv; falls back to python3 on PATH.
require("dap-python").setup(os.getenv("NVIM_DEBUGPY_PYTHON") or "python3")

dapui.setup({
	layouts = {
		{
			elements = {
				{ id = "scopes",      size = 0.35 },
				{ id = "watches",     size = 0.25 },
				{ id = "stacks",      size = 0.25 },
				{ id = "breakpoints", size = 0.15 },
			},
			size = 50,          -- sidebar width in columns (default 40)
			position = "left",
		},
		{
			elements = {
				{ id = "repl",    size = 0.6 },   -- give the repl more room than console
				{ id = "console", size = 0.4 },
			},
			size = 15,          -- bottom tray height in rows (default 10)
			position = "bottom",
		},
	},
})
require("nvim-dap-virtual-text").setup()

-- VSCode-style gutter icons
vim.fn.sign_define("DapBreakpoint",         { text = "●", texthl = "DapBreakpoint",         linehl = "", numhl = "" })
vim.fn.sign_define("DapBreakpointCondition",{ text = "◐", texthl = "DapBreakpointCondition", linehl = "", numhl = "" })
vim.fn.sign_define("DapBreakpointRejected", { text = "●", texthl = "DapBreakpointRejected",  linehl = "", numhl = "" })
vim.fn.sign_define("DapLogPoint",           { text = "◆", texthl = "DapLogPoint",            linehl = "", numhl = "" })
vim.fn.sign_define("DapStopped",            { text = "▶", texthl = "DapStopped",             linehl = "DapStoppedLine", numhl = "" })

vim.api.nvim_set_hl(0, "DapBreakpoint",          { fg = "#e51400" })
vim.api.nvim_set_hl(0, "DapBreakpointCondition", { fg = "#e51400" })
vim.api.nvim_set_hl(0, "DapBreakpointRejected",  { fg = "#888888" })
vim.api.nvim_set_hl(0, "DapLogPoint",            { fg = "#61afef" })
vim.api.nvim_set_hl(0, "DapStopped",             { fg = "#ffcc00" })
vim.api.nvim_set_hl(0, "DapStoppedLine",         { bg = "#2e2d2d" })

-- Auto open/close UI with debug sessions
dap.listeners.before.attach.dapui_config = function() dapui.open() end
dap.listeners.before.launch.dapui_config = function() dapui.open() end
dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
dap.listeners.before.event_exited.dapui_config = function() dapui.close() end

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
map("n", "<leader>d=", "<cmd>resize +5<cr>",          { desc = "DAP window taller" })
map("n", "<leader>d-", "<cmd>resize -5<cr>",          { desc = "DAP window shorter" })
map("n", "<leader>d>", "<cmd>vertical resize +5<cr>", { desc = "DAP window wider" })
map("n", "<leader>d<", "<cmd>vertical resize -5<cr>", { desc = "DAP window narrower" })
map("n", "<leader>dm", function() require("dap-python").test_method() end, { desc = "Debug test method" })
map("n", "<leader>dM", function() require("dap-python").test_class() end, { desc = "Debug test class" })
