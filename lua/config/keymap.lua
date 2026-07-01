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

		-- Inlay hints: enable on attach when the server supports them, toggle with <leader>uh
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if client and client:supports_method("textDocument/inlayHint") then
			vim.lsp.inlay_hint.enable(true, { bufnr = buf })
			vim.keymap.set("n", "<leader>uh", function()
				vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = buf }), { bufnr = buf })
			end, { buffer = buf, desc = "Toggle inlay hints" })
		end

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

-- Full-file Git blame from GitSigns: scrollable side split, `q` to return to the file
vim.keymap.set("n", "<leader>gb", function()
	require("gitsigns").blame()
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

-- Clear search highlight
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })

-- Window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- Move selected lines up/down, re-indenting to the new context
vim.keymap.set("v", "J", ":m '>+1<cr>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "K", ":m '<-2<cr>gv=gv", { desc = "Move selection up" })

-- Re-indent in visual mode without losing the selection
vim.keymap.set("v", "<", "<gv", { desc = "Dedent selection" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent selection" })
