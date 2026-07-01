-- Path comes from $NVIM_LUA_LS (set in ~/.config/shell/shell_settings.sh);
-- falls back to a PATH lookup if the env var is unset.
local lua_ls_cmd = os.getenv("NVIM_LUA_LS") or vim.fn.exepath("lua-language-server")

vim.lsp.config("lua_ls", {
	cmd = { lua_ls_cmd },
	capabilities = require("blink.cmp").get_lsp_capabilities(),
	filetypes = { "lua" },
	root_markers = { ".luarc.json", ".luarc.jsonc", ".luacheckrc", ".stylua.toml", "stylua.toml", ".git" },
	settings = {
		Lua = {
			runtime = { version = "LuaJIT" },
			workspace = { library = { vim.fn.stdpath("config"), vim.env.VIMRUNTIME } },
			telemetry = { enable = false },
			checkThirdParty = false,
		},
	},
})

vim.lsp.enable("lua_ls")
