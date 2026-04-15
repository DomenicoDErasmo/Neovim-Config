local lspconfig = require("lspconfig")
local capabilities = require("blink.cmp").get_lsp_capabilities()
local configs = require("lspconfig.configs")

-- Register ty as a custom language server if not already registered
if not configs.ty then
	configs.ty = {
		default_config = {
			cmd = { os.getenv("HOME") .. "/.local/bin/ty", "server" },
			filetypes = { "python" },
			root_dir = function(fname)
				-- Prioritize ty.toml (repo root) so ty finds its config correctly.
				-- pyproject.toml exists in many subdirectories and would otherwise
				-- anchor ty to a subdir that has no ty.toml.
				return lspconfig.util.root_pattern("ty.toml")(fname)
					or lspconfig.util.root_pattern(".git")(fname)
			end,
			settings = {},
		},
	}
end

-- Suppress -32802 (ContentModified): fired when a request is cancelled because
-- the document changed mid-flight. Comes through vim.notify, not on_error.
-- Guard against double-wrapping on re-source.
if not package.loaded["_ty_notify_filtered"] then
	package.loaded["_ty_notify_filtered"] = true
	local _notify = vim.notify
	vim.notify = function(msg, level, opts)
		if type(msg) == "string" and msg:find("-32802", 1, true) then
			return
		end
		_notify(msg, level, opts)
	end
end

-- Setup ty language server (reads config from pyproject.toml)
lspconfig.ty.setup({
	capabilities = capabilities,
})
