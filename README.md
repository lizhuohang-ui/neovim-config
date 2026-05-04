# Freebird's Neovim Configuration

A modular, lazy-loaded Neovim configuration powered by [lazy.nvim](https://github.com/folke/lazy.nvim).

![Neovim](https://img.shields.io/badge/Neovim-%3E%3D%200.10-blue?logo=neovim)
![Lua](https://img.shields.io/badge/Lua-100%25-blue)

## ✨ Features

- **Lazy-loading** — Plugins load only when needed, startup time is fast
- **Modern LSP** — Code completion, diagnostics, formatting, and hover docs
- **Debugging** — Full DAP support with UI, virtual text, and Mason integration
- **Beautiful UI** — Nord colorscheme, bufferline, lualine, dashboard, and noice
- **Git Integration** — LazyGit directly inside Neovim
- **Markdown Preview** — Live preview in browser
- **Session Management** — Save and restore sessions
- **Snippets** — LuaSnip with friendly-snippets collection
- **C/C++ Enhancements** — clangd inlay hints and AST view
- **AI Integration** — GitHub Copilot suggestions and OpenCode chat agent

## 📦 Prerequisites

| Requirement | Version | Notes |
|---|---|---|
| [Neovim](https://github.com/neovim/neovim) | ≥ 0.10 | Required |
| [Git](https://git-scm.com/) | any | For lazy.nvim bootstrap |
| [LazyGit](https://github.com/jesseduffield/lazygit) | any | For `<leader>g` git UI |
| [yarn](https://yarnpkg.com/) | any | For markdown-preview build |
| Nerd Font | any | For icons (optional but recommended) |
| C/C++ compiler | any | For treesitter and LuaSnip jsregexp |

## 🚀 Quick Start

```bash
# 1. Backup your existing config (if any)
mv ~/.config/nvim ~/.config/nvim.bak

# 2. Clone this configuration
git clone https://github.com/<your-username>/nvim-config.git ~/.config/nvim

# 3. Launch Neovim — lazy.nvim auto-installs, then plugins install
nvim
```

First launch will:
1. Clone lazy.nvim automatically
2. Install all plugins (defined in `lua/plugins/`)
3. Build markdown-preview and LuaSnip jsregexp

Wait for the installation to complete, then restart Neovim.

## 🗂️ Directory Structure

```
~/.config/nvim/
├── init.lua                  # Entry point — sets leader, loads configs, bootstraps lazy.nvim
├── lazy-lock.json            # Plugin version lockfile (auto-generated)
├── lua/
│   ├── config/
│   │   ├── options.lua       # Editor options (line numbers, tabs, clipboard, etc.)
│   │   └── keymaps.lua       # Global keybindings (window nav, escape shortcuts)
│   └── plugins/
│       ├── init.lua          # Core plugins (startuptime, neoconf, neodev, neorg)
│       ├── editor.lua        # File explorer, fuzzy finder, search/replace, which-key
│       ├── ui.lua            # Colorscheme, bufferline, statusline, dashboard, noice
│       ├── lsp.lua           # LSP configuration (lua, python, C/C++, verilog, etc.)
│       ├── coding.lua        # Completion (nvim-cmp), snippets, autopairs, comments
│       ├── treesitter.lua    # Syntax highlighting and indentation
│       ├── git.lua           # LazyGit integration
│       ├── debug.lua         # nvim-dap with UI, virtual text, Mason integration
│       ├── mason.lua         # LSP/Formatter/Linter/Debugger installer
│       ├── markdown.lua      # Live markdown preview
│       ├── c_cpp.lua         # clangd extensions (inlay hints, AST)
│       ├── ai.lua            # Copilot and OpenCode AI integration
│       ├── todo.lua          # Todo list management
│       └── util.lua          # Session persistence
```

## ⌨️ Keybindings

Leader key is `<Space>`.

### Window Management

| Key | Action |
|---|---|
| `<C-h/j/k/l>` | Navigate between windows |
| `<leader>wv` | Vertical split |
| `<leader>ws` | Horizontal split |

### Buffer Management

| Key | Action |
|---|---|
| `<S-h>` / `<S-l>` | Previous / Next buffer |
| `<leader>bc` | Close current buffer |
| `<leader>br` | Close buffers to the right |
| `<leader>bl` | Close buffers to the left |
| `<leader>bo` | Close other buffers |

### File Explorer (neo-tree)

| Key | Action |
|---|---|
| `<leader>e` | Toggle file explorer |
| `l` / `h` | Open / Close node |
| `Y` | Copy file path to clipboard |
| `P` | Toggle preview |

### Fuzzy Finder (Telescope)

| Key | Action |
|---|---|
| `<leader>ff` | Find files |
| `<leader>fo` | Recent files |
| `<leader>fg` | Live grep |
| `<leader>fr` | Resume last search |
| `<leader>fh` | Help tags |

### Search & Jump (flash.nvim)

| Key | Mode | Action |
|---|---|---|
| `s` | `n/x/o` | Flash jump |
| `S` | `n/o/x` | Flash Treesitter jump |
| `<leader>sr` | `n/v` | Search and replace (grug-far) |

### LSP

| Key | Action |
|---|---|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gi` | Go to implementation |
| `gr` | Find references |
| `K` | Hover documentation |
| `<leader>k` | Signature help |
| `<leader>D` | Type definition |
| `<leader>rn` | Rename symbol |
| `<leader>ca` | Code actions |
| `<leader>fm` | Format document |
| `[d` / `]d` | Previous / Next diagnostic |

### Debugging (nvim-dap)

| Key | Action |
|---|---|
| `<leader>db` | Toggle breakpoint |
| `<leader>dB` | Conditional breakpoint |
| `<leader>dc` | Continue |
| `<leader>da` | Run with arguments |
| `<leader>dC` | Run to cursor |
| `<leader>di` | Step into |
| `<leader>do` | Step out |
| `<leader>dO` | Step over |
| `<leader>dr` | Toggle REPL |
| `<leader>dt` | Terminate |
| `<leader>du` | Toggle DAP UI |
| `<leader>de` | Evaluate expression |

### Git

| Key | Action |
|---|---|
| `<leader>g` | Open LazyGit |

### Markdown

| Key | Action |
|---|---|
| `<leader>mp` | Markdown preview in browser |

### Session Management

| Key | Action |
|---|---|
| `<leader>qs` | Restore session |
| `<leader>ql` | Restore last session |
| `<leader>qd` | Don't save current session |

### AI

| Key | Action |
|---|---|
| `<M-l>` | Accept Copilot suggestion |
| `<M-]>` / `<M-[>` | Next / Previous Copilot suggestion |
| `<M-CR>` | Open Copilot panel |
| `<leader>oo` | Toggle OpenCode chat |
| `<leader>on` | New OpenCode session |
| `<leader>or` | Run OpenCode prompt |

### Other

| Key | Action |
|---|---|
| `jk` / `kj` | Exit insert mode |
| `<leader>l` | Open Lazy dashboard |
| `<leader>t` | Translate word |
| `F2` | Toggle LazyDo todo list |

## 🎨 Colorscheme

[Nord](https://github.com/shaunsingh/nord.nvim) is the default. To change it, edit `lua/plugins/ui.lua`:

```lua
-- Replace "nord.nvim" with your preferred colorscheme
-- Then update the config function to call your colorscheme
```

## 🧩 Key Plugins

### Language Support

| Language | LSP | Formatter | Linter |
|---|---|---|---|
| Lua | lua_ls | — | — |
| Python | pyright | — | — |
| C/C++ | clangd | — | — |
| Verilog/SystemVerilog | verible | — | — |
| Markdown | grammarly | — | — |

Edit `lua/plugins/mason.lua` to add more tools.

### Treesitter Languages

Pre-installed parsers: `c`, `cpp`, `lua`, `vim`, `vimdoc`, `markdown`, `python`.

Run `:TSInstall <language>` to add more.

## 🔧 Customization

### Adding Plugins

Create a new file in `lua/plugins/` following the lazy.nvim spec format:

```lua
-- lua/plugins/my-plugin.lua
return {
  {
    "author/plugin-name",
    event = "VeryLazy",
    keys = {
      { "<leader>x", "<cmd>MyCommand<cr>", desc = "My action" },
    },
    config = function()
      require("plugin-name").setup({})
    end,
  },
}
```

### Changing Options

Edit `lua/config/options.lua` for editor settings and `lua/config/keymaps.lua` for keybindings.

### Lazy.nvim

- `<leader>l` — Open Lazy dashboard
- `:Lazy` — Manage plugins
- `:Lazy profile` — Profile startup time
- `:Lazy sync` — Sync plugin state

## 📝 Notes

- `lazy-lock.json` pins plugin versions — commit it to share a reproducible setup
- The config uses `event = "VeryLazy"` extensively for fast startup
- LazyGit must be installed separately for `<leader>g` to work
- For Neovide GUI, transparency is set to `0.8` in `options.lua`
- Session data is not committed (handled by persistence.nvim)

## 📄 License

MIT
