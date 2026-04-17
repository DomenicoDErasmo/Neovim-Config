local lua_ls_cmd = vim.fn.exepath("lua-language-server")
if lua_ls_cmd == "" then
	lua_ls_cmd = vim.fn.expand("~/opt/lua-language-server/bin/lua-language-server")
end

vim.lsp.config("lua_ls", {
	cmd = { lua_ls_cmd },
	capabilities = require("blink.cmp").get_lsp_capabilities(),
	filetypes = { "lua" },
	root_markers = { ".luarc.json", ".luarc.jsonc", ".luacheckrc", ".stylua.toml", "stylua.toml", ".git" },
	settings = {
		Lua = {
			runtime = { version = "LuaJIT" },
			workspace = { library = vim.api.nvim_get_runtime_file("", true) },
			telemetry = { enable = false },
			checkThirdParty = false,
		},
	},
})

vim.lsp.enable("lua_ls")
