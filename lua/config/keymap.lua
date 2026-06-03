vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local buf = args.buf

		-- Go to definition
		-- Related, jump lists:
		-- Ctrl+o to jump back and Ctrl-i to jump forward
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = buf, desc = "Go to definition" })
		-- References
		vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = buf, desc = "References" })
		-- Type definition
		vim.keymap.set("n", "gy", vim.lsp.buf.type_definition, { buffer = buf, desc = "Type definition" })
		-- Go to implementation
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { buffer = buf, desc = "Go to implementation" })
		-- Rename symbol
		vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = buf, desc = "Rename symbol" })
		-- Code actions
		vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = buf, desc = "Code action" })

		-- Highlight references to symbol under cursor
		local group = vim.api.nvim_create_augroup("LspDocumentHighlight_" .. buf, { clear = true })
		vim.api.nvim_create_autocmd("CursorHold", {
			buffer = buf,
			group = group,
			callback = function()
				if #vim.lsp.get_clients({ bufnr = buf, method = "textDocument/documentHighlight" }) > 0 then
					vim.lsp.buf.document_highlight()
				end
			end,
		})
		vim.api.nvim_create_autocmd({ "CursorMoved", "InsertEnter" }, {
			buffer = buf,
			group = group,
			callback = vim.lsp.buf.clear_references,
		})
	end,
})

-- Show diagnostic in a floating window
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show LSP Diagnostic" })

-- Jump to next/previous diagnostic
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next Diagnostic" })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous Diagnostic" })

-- Full Git blame info from GitSigns; second call focuses the popup so it's scrollable
vim.keymap.set("n", "<leader>gb", function()
	local gs = require("gitsigns")
	gs.blame_line({ full = true })
	vim.defer_fn(function()
		gs.blame_line({ full = true })
	end, 50)
end, { desc = "View full Git blame" })

-- Diff of the commit that last touched the current line
vim.keymap.set("n", "<leader>gd", function()
	local file = vim.fn.expand("%:p")
	if file == "" or vim.fn.filereadable(file) == 0 then
		vim.notify("No file for current buffer", vim.log.levels.WARN)
		return
	end
	local line = vim.fn.line(".")
	local out = vim.fn.systemlist({
		"git", "-C", vim.fn.fnamemodify(file, ":h"),
		"blame", "-L", line .. "," .. line, "--porcelain", file,
	})
	if vim.v.shell_error ~= 0 or #out == 0 then
		vim.notify("git blame failed", vim.log.levels.ERROR)
		return
	end
	local sha = out[1]:match("^(%x+)")
	if not sha or sha:match("^0+$") then
		vim.notify("Line is uncommitted", vim.log.levels.INFO)
		return
	end
	vim.cmd("DiffviewOpen " .. sha .. "^!")
end, { desc = "Diff commit that changed current line" })

-- Open Oil
vim.keymap.set("n", "<leader>o", "<cmd>Oil<cr>", { desc = "Open file browser" })

-- Open Neogit UI
vim.keymap.set("n", "<leader>gg", "<cmd>Neogit<cr>", { desc = "Open Neogit UI" })
-- Git commit
vim.keymap.set("n", "<leader>gc", "<cmd>Neogit commit<cr>", { desc = "Git commit" })
-- Git pull / push
vim.keymap.set("n", "<leader>gp", "<cmd>Neogit pull<cr>", { desc = "Git pull" })
vim.keymap.set("n", "<leader>gP", "<cmd>Neogit push<cr>", { desc = "Git push" })

-- Close tab
vim.keymap.set("n", "<leader>tc", "<cmd>tabclose<CR>", { desc = "Close tab" })

-- Trouble diagnostics
vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "View all diagnostics" })

vim.keymap.set(
	"n",
	"<leader>xb",
	"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
	{ desc = "View diagnostics in current buffer" }
)

vim.keymap.set("n", "<leader>xs", "<cmd>Trouble symbols toggle<cr>", { desc = "Symbols outline" })
vim.keymap.set("n", "<leader>xr", "<cmd>Trouble lsp_references toggle<cr>", { desc = "LSP references" })

-- Find and replace
vim.keymap.set("n", "<leader>fr", "<cmd>GrugFar<cr>", { desc = "Find and replace (grug-far)" })
vim.keymap.set("v", "<leader>fr", function()
	require("grug-far").open()
end, { desc = "Find and replace selection (grug-far)" })

-- Undotree toggle
vim.keymap.set("n", "<leader><F5>", vim.cmd.UndotreeToggle, { desc = "Toggle Undotree" })
