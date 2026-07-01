# Neovim config

A modern Lua config built on [lazy.nvim](https://github.com/folke/lazy.nvim),
native LSP (`vim.lsp.config`/`vim.lsp.enable`), [blink.cmp](https://github.com/saghen/blink.cmp),
`conform.nvim` (format) and `nvim-lint` (lint).

## Requirements

- **Neovim ≥ 0.11** — the LSP configs use `vim.lsp.config` / `vim.lsp.enable`,
  which do not exist on 0.10.
- A C compiler + `make` (for `telescope-fzf-native`) and `cargo` (for `blink.cmp`).
- External tools per language (see below); anything not found is simply skipped.

## Environment variables

Tool paths are read from the environment so they can live in your shell config
instead of being hardcoded here. Every one has a fallback, so the config works
without setting any of them — set a variable only when the tool isn't on your
`PATH` or you want a specific binary.

| Variable | Used for | Fallback if unset |
|----------|----------|-------------------|
| `NVIM_CLANGD` | `clangd` LSP command (C/C++) | `clangd` on `PATH` |
| `NVIM_LUA_LS` | `lua-language-server` LSP command | `lua-language-server` on `PATH` |
| `NVIM_TY` | [`ty`](https://github.com/astral-sh/ty) binary — both the Python LSP server *and* the `ty check` linter | `ty` on `PATH` |
| `NVIM_DEBUGPY_PYTHON` | Python interpreter for `nvim-dap` (must have `debugpy` installed) | `python3` on `PATH` |
| `NVIM_VENV_DIR` | Directory of shared venvs for `venv-selector`; when set, adds a custom search. When **unset**, `venv-selector`'s default searches are used instead. | *(default searches)* |

### Example (`~/.bashrc`, `~/.zshrc`, or a sourced shell file)

```bash
export NVIM_CLANGD='/path/to/clangd'
export NVIM_LUA_LS="$HOME/opt/lua-language-server/bin/lua-language-server"
export NVIM_TY='/path/to/ty'
export NVIM_DEBUGPY_PYTHON="$HOME/.venvs/dev/bin/python"
export NVIM_VENV_DIR="$HOME/.venvs"
```

> These are read at Neovim startup, so set them in a shell file that's sourced
> before you launch `nvim` (open a new shell after editing).

## External tools

Beyond the LSP servers above, these are used if present:

- **Formatters** (`conform.nvim`): `stylua` (Lua), `prettier` (Markdown),
  `ruff` (Python), `clang-format` (C/C++), `buf` (protobuf).
- **Linters** (`nvim-lint`): `ruff` and `ty` (Python), `markdownlint-cli2`
  (Markdown — found on `PATH`, else `~/node_modules/.bin/markdownlint-cli2`).
- **Search**: `ripgrep` (`rg`) and `fd` power Telescope and `venv-selector`.

## Layout

```
init.lua              -- entry point; requires config.* modules
lua/config/
  lazy.lua            -- plugin-manager bootstrap
  plugins.lua         -- plugin specs
  globals.lua         -- options / autocommands
  keymap.lua          -- keymaps (leader = <Space>)
  paths.lua           -- external tool paths (ruff, ty)
  lsp/                -- per-server LSP configs (cpp, lua, python, proto)
  *.lua               -- one file per plugin/feature
```
