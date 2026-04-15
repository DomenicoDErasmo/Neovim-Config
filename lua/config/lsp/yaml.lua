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
	return "yaml-language-server" -- let lspconfig surface the error
end

require("lspconfig").yamlls.setup({
	cmd = { find_yaml_ls(), "--stdio" },
	root_dir = require("lspconfig.util").root_pattern(".git", ".yaml-root"),
	settings = {
		yaml = {
			-- gets from config repo
			schemas = {
				["/usr/scratch/domenico/checkouts/config/conf/commissions/incentives/incentives_schema.json"] = "incentive_programs*.yaml",
			},
		},
	},
})
