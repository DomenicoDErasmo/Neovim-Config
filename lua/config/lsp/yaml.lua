local function find_yaml_ls()
	local p = vim.fn.exepath("yaml-language-server")
	if p ~= "" then
		return p
	end
	local nvm_bin = os.getenv("NVM_BIN")
	if nvm_bin then
		p = nvm_bin .. "/yaml-language-server"
		if vim.fn.filereadable(p) == 1 then
			return p
		end
	end
	-- NVM_BIN may point to a different node version than where the server is
	-- installed; scan all nvm versions as a fallback
	local nvm_dir = os.getenv("NVM_DIR") or (os.getenv("HOME") .. "/.nvm")
	local versions = vim.fn.glob(nvm_dir .. "/versions/node/*/bin/yaml-language-server", false, true)
	if #versions > 0 then
		return versions[#versions] -- prefer the last (highest) version
	end
	return "yaml-language-server" -- let nvim surface the error
end

vim.lsp.config("yamlls", {
	cmd = { find_yaml_ls(), "--stdio" },
	capabilities = require("blink.cmp").get_lsp_capabilities(),
	filetypes = { "yaml", "yaml.docker-compose" },
	root_markers = { ".yaml-root", ".git" },
})

vim.lsp.enable("yamlls")
