require("gitsigns").setup({
	current_line_blame = true,
	current_line_blame_opts = {
		virt_text = true,
		virt_text_pos = "eol",
		delay = 300,
	},
	current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
	on_attach = function(bufnr)
		local gs = require("gitsigns")
		local function map(mode, l, r, opts)
			opts = opts or {}
			opts.buffer = bufnr
			vim.keymap.set(mode, l, r, opts)
		end

		map("n", "]c", function()
			if vim.wo.diff then vim.cmd.normal({ "]c", bang = true })
			else gs.nav_hunk("next") end
		end, { desc = "Next hunk" })
		map("n", "[c", function()
			if vim.wo.diff then vim.cmd.normal({ "[c", bang = true })
			else gs.nav_hunk("prev") end
		end, { desc = "Prev hunk" })

		map("n", "<leader>hs", gs.stage_hunk, { desc = "Stage hunk" })
		map("n", "<leader>hr", gs.reset_hunk, { desc = "Reset hunk" })
		map("n", "<leader>hp", gs.preview_hunk, { desc = "Preview hunk" })
		map("v", "<leader>hs", function()
			gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end, { desc = "Stage hunk" })
		map("v", "<leader>hr", function()
			gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end, { desc = "Reset hunk" })

		map("n", "<leader>hS", gs.stage_buffer, { desc = "Stage buffer" })
		map("n", "<leader>hR", gs.reset_buffer, { desc = "Reset buffer" })
	end,
})
