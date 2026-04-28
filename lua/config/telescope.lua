require("telescope").setup({
	extensions = {
		fzf = {
			fuzzy = true,
			override_generic_sorter = true,
			override_file_sorter = true,
		},
	},
})

require("telescope").load_extension("fzf")

local telescope_builtin = require("telescope.builtin")

vim.keymap.set("n", "<leader>fa", function()
	telescope_builtin.find_files({
		find_command = { "rg", "--files", "--glob", "!.git/*" },
	})
end, { desc = "Telescope find files (exclude hidden files)" })
vim.keymap.set("n", "<leader>ff", function()
	telescope_builtin.find_files({
		find_command = { "rg", "--files", "--hidden", "--glob", "!.git/*" },
	})
end, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>fg", telescope_builtin.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("n", "<leader>fG", function()
	telescope_builtin.live_grep({ additional_args = { "--fixed-strings" } })
end, { desc = "Telescope live grep (exact)" })
vim.keymap.set("n", "<leader>ft", function()
	telescope_builtin.live_grep({
		prompt_title = "Live Grep (filetype)",
		additional_args = function()
			local glob = vim.fn.input("Glob filter: ")
			return glob ~= "" and { "--glob", glob } or {}
		end,
	})
end, { desc = "Telescope live grep (filetype)" })
vim.keymap.set("n", "<leader>fo", telescope_builtin.oldfiles, { desc = "Telescope recent files" })
vim.keymap.set("n", "<leader>fb", telescope_builtin.buffers, { desc = "Telescope buffers" })
vim.keymap.set("n", "<leader>fh", telescope_builtin.help_tags, { desc = "Telescope help tags" })
vim.keymap.set("n", "<leader>fs", telescope_builtin.lsp_document_symbols, { desc = "Document symbols" })
vim.keymap.set("n", "<leader>fS", telescope_builtin.lsp_dynamic_workspace_symbols, { desc = "Workspace symbols" })
