local lua_ls_cmd = vim.fn.exepath("lua-language-server")
if lua_ls_cmd == "" then
  lua_ls_cmd = vim.fn.expand("~/opt/lua-language-server/bin/lua-language-server")
end

local lspconfig = require("lspconfig")

lspconfig.lua_ls.setup({
	cmd = { lua_ls_cmd },
	capabilities = require("blink.cmp").get_lsp_capabilities(),
	settings = {
		Lua = {
			runtime = { version = "LuaJIT" },
			workspace = { library = vim.api.nvim_get_runtime_file("", true) },
			telemetry = { enable = false },
		},
	},
})
