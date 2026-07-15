local lua_ls_cmd = require("config.paths").lua_ls

require("config.lsp").setup("lua_ls", {
  cmd = { lua_ls_cmd },
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
