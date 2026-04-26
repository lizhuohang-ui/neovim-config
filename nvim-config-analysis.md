# Neovim Config Analysis Report

> Generated: 2026-04-26 | Config: `/home/freebird/.config/nvim` | Plugin Manager: lazy.nvim

---

## Executive Summary

This config uses **lazy.nvim** with a modular plugin structure across 16 Lua files. Overall architecture is sound but 6 critical issues need immediate attention, 9 warnings should be addressed, and 10 suggestions would improve maintainability.

**Key takeaway**: The config blends Neovim 0.11+ APIs (`vim.lsp.config`/`vim.lsp.enable`) with an archived plugin (`null-ls.nvim`) and contains broken references to LazyVim distribution APIs that don't exist in a standalone lazy.nvim setup. The `.luarc.json` is hardcoded to a different user's home directory.

---

## Critical Issues

### 1. 🔴 `.luarc.json` — Hardcoded Paths to Wrong User

- **File**: `/home/freebird/.config/nvim/lua/.luarc.json`
- **Lines**: 3–24
- **Severity**: CRITICAL

All `workspace.library` paths reference `/home/lizhuohang/`, but the config lives under `/home/freebird/`. These paths are completely broken on the current machine, which means **Lua language server cannot resolve any plugin types**.

```json
"/home/lizhuohang/.local/share/nvim/lazy/neodev.nvim/types/stable",
"/home/lizhuohang/.local/share/nvim/lazy/cmp-nvim-lsp/lua",
...
```

**Fix**: Replace all `/home/lizhuohang/` with `/home/freebird/` (or the actual home directory).

> Also: `"${3rd}/luv/library"` is duplicated 4 times on lines 25-28. Remove 3 duplicates.

---

### 2. 🔴 `null-ls.nvim` — Archived & Unmaintained

- **File**: `/home/freebird/.config/nvim/lua/plugins/lsp.lua`
- **Line**: 47
- **Severity**: CRITICAL

`jose-elias-alvarez/null-ls.nvim` was **archived in August 2023** and receives no updates. It will eventually break with newer Neovim versions.

```lua
"jose-elias-alvarez/null-ls.nvim",   -- ARCHIVED!
```

**Fix**: Migrate to the community-maintained fork `nvimtools/none-ls.nvim`. Replace the spec and update the require paths.

---

### 3. 🔴 Dashboard — References Non-Existent LazyVim APIs

- **File**: `/home/freebird/.config/nvim/lua/plugins/ui.lua`
- **Lines**: 146, 148, 150, 152
- **Severity**: CRITICAL

The dashboard-nvim config references `LazyVim.pick()` and `LazyExtras` command — these belong to the **LazyVim distribution**, not the `lazy.nvim` plugin manager. Clicking these items will produce runtime errors.

```lua
{ action = 'lua LazyVim.pick()()',             desc = " Find File",       icon = " ", key = "f" },    -- BROKEN
{ action = 'lua LazyVim.pick("oldfiles")()',    desc = " Recent Files",    icon = " ", key = "r" },    -- BROKEN
{ action = 'lua LazyVim.pick.config_files()()', desc = " Config",          icon = " ", key = "c" },    -- BROKEN
{ action = "LazyExtras",                        desc = " Lazy Extras",     icon = " ", key = "x" },    -- BROKEN
```

Also line 149: `action = 'lua '` is incomplete (missing command).

**Fix**: Replace with telescope commands or simple `require()` calls, e.g.:
- Find File → `"Telescope find_files"`
- Recent Files → `"Telescope oldfiles"`
- Config → `"Telescope find_files cwd=~/.config/nvim"`
- Remove LazyExtras entry entirely

---

### 4. 🔴 `debug.lua` — Undefined Variable `get_args`

- **File**: `/home/freebird/.config/nvim/lua/plugins/debug.lua`
- **Line**: 94
- **Severity**: CRITICAL

```lua
{ "<leader>da", function() require("dap").continue({ before = get_args }) end, desc = "Run with Args" },
```

The variable `get_args` is **never defined** anywhere in the codebase. Pressing `<leader>da` will throw a Lua runtime error.

**Fix**: Either define `get_args` (e.g., `local function get_args() return vim.fn.input("Args: ") end`) or remove this keymap.

---

### 5. 🔴 `lsp.lua` — Accessing Removed API `formatting_sync`

- **File**: `/home/freebird/.config/nvim/lua/plugins/lsp.lua`
- **Line**: 14
- **Severity**: CRITICAL (on Neovim ≥ 0.10)

```lua
vim.lsp.buf.formatting_sync = nil
```

`vim.lsp.buf.formatting_sync` was **deprecated in 0.9 and removed in 0.10**. This line will throw an error on Neovim 0.10+ because you cannot assign to a non-existent field.

**Fix**: Remove this line entirely. If you need to disable synchronous formatting, use the proper API:
```lua
vim.lsp.buf.format({ async = true })
```

---

### 6. 🔴 `init.lua` — `vim.loop` Deprecated

- **File**: `/home/freebird/.config/nvim/init.lua`
- **Line**: 9
- **Severity**: CRITICAL (warning in 0.10, may be removed entirely)

```lua
if not vim.loop.fs_stat(lazypath) then
```

`vim.loop` is deprecated since Neovim 0.10. Though it still works as an alias, it may be removed in a future version.

**Fix**: Replace with `vim.uv`:
```lua
if not vim.uv.fs_stat(lazypath) then
```

---

## Warnings

### 7. 🟡 `init.lua` — LSP Config Before Plugin Loading

- **File**: `/home/freebird/.config/nvim/init.lua`
- **Lines**: 25–36, 43, 50–85
- **Severity**: WARNING

`require("mason").setup()` and `require("mason-lspconfig").setup()` are called in `init.lua` (lines 25-36), while the plugin spec in `mason.lua` has its `config` function **commented out**. This creates a confusing split: some setup is in `init.lua`, some in plugin specs.  Additionally, `vim.lsp.config.*`/`vim.lsp.enable()` calls (lines 50-85) are Neovim 0.11+ APIs — they will fail silently on 0.10 or earlier.

The `require("cmp_nvim_lsp").default_capabilities()` call on line 43 depends on `nvim-cmp` being loaded (it loads eagerly, so this works, but it's fragile).

**Fix**: 
1. Move Mason setup into `mason.lua`'s config function (uncomment line 5-7)
2. Move `mason-lspconfig` setup into a proper plugin spec
3. Consider using `lspconfig` instead of `vim.lsp.config` for Neovim < 0.11 compatibility, or add a version guard

---

### 8. 🟡 `coding.lua` — Require Before Lazy-Load

- **File**: `/home/freebird/.config/nvim/lua/plugins/coding.lua`
- **Line**: 29
- **Severity**: WARNING

```lua
local cmp_autopairs = require("nvim-autopairs.completion.cmp")
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
```

`nvim-autopairs` is configured with `event = "VeryLazy"` (line 133, same file). This means it loads AFTER `UIEnter`. But `nvim-cmp` (which contains line 29) loads eagerly (no lazy trigger). There's a **potential race condition** where `nvim-autopairs` hasn't loaded yet when `cmp` tries to require it.

Note: In practice, this often works because lazy.nvim resolves dependencies eagerly for non-lazy plugins, but it's not guaranteed.

**Fix**: Add `"windwp/nvim-autopairs"` as a dependency of the nvim-cmp spec, OR use `cmp.event:on("ready", ...)` pattern, OR make nvim-autopairs load earlier.

---

### 9. 🟡 `ui.lua` — Debug `vim.print` Left in Production

- **File**: `/home/freebird/.config/nvim/lua/plugins/ui.lua`
- **Line**: 27
- **Severity**: WARNING

```lua
vim.print("bufferline")
```

This prints `"bufferline"` to the messages area every time bufferline loads.

**Fix**: Remove the line.

---

### 10. 🟡 `options.lua` — Debug `vim.print` in neovide branch

- **File**: `/home/freebird/.config/nvim/lua/config/options.lua`
- **Line**: 12
- **Severity**: WARNING

```lua
vim.print(vim.g.neovide_version)
```

Prints neovide version on every startup when using Neovide. Minor but noisy.

**Fix**: Remove or guard behind a debug flag.

---

### 11. 🟡 `ui.lua` — `dependencies` as String, Not Table

- **File**: `/home/freebird/.config/nvim/lua/plugins/ui.lua`
- **Line**: 16
- **Severity**: WARNING

```lua
dependencies = 'nvim-tree/nvim-web-devicons',
```

Lazy.nvim expects `dependencies` to be a **table** (list). A string may not resolve correctly.

**Fix**:
```lua
dependencies = { 'nvim-tree/nvim-web-devicons' },
```

---

### 12. 🟡 `ui.lua` — Typo "Nexe"

- **File**: `/home/freebird/.config/nvim/lua/plugins/ui.lua`
- **Line**: 23
- **Severity**: WARNING

```lua
{ "<S-l>", "<Cmd>BufferLineCycleNext<CR>", desc = "Nexe buffer" },
```

Should be `"Next buffer"`.

---

### 13. 🟡 `uitl.lua` — Filename Typo

- **File**: `/home/freebird/.config/nvim/lua/plugins/uitl.lua`
- **Severity**: WARNING

Filename `uitl.lua` looks like a typo for `util.lua`. While lazy.nvim auto-discovers plugin files regardless of name, this could cause confusion if someone tries to `require("plugins.uitl")`.

**Fix**: Rename to `util.lua`.

---

### 14. 🟡 `lazy-lock.json` — Orphaned Plugins

- **File**: `/home/freebird/.config/nvim/lazy-lock.json`
- **Severity**: WARNING

Three plugins are pinned in the lock file but **not referenced by any plugin spec**:
- `lua-utils.nvim`
- `pathlib.nvim`
- `nvim-nio`

These are stale lock entries. Run `:Lazy clean` to remove unused plugins, then `:Lazy restore` to update the lock file.

---

### 15. 🟡 `keymaps.lua` — Incomplete Comment

- **File**: `/home/freebird/.config/nvim/lua/config/keymaps.lua`
- **Line**: 16
- **Severity**: WARNING

```lua
-- easily 
```

Incomplete comment. Should be removed or completed.

---

## Suggestions

### 16. 💡 `format.lua` — Entirely Commented Out

- **File**: `/home/freebird/.config/nvim/lua/plugins/format.lua`
- **Severity**: SUGGESTION

This file is 100% commented-out code (46 lines). It serves no purpose. Either delete it or uncomment and configure `conform.nvim`.

---

### 17. 💡 `todo.lua` — Dead Old Plugin Code

- **File**: `/home/freebird/.config/nvim/lua/plugins/todo.lua`
- **Lines**: 1–8
- **Severity**: SUGGESTION

The old `dooing` plugin config is commented out at the top. Remove it to keep the file clean.

---

### 18. 💡 `init.lua` — Large Blocks of Commented-Out Code

- **File**: `/home/freebird/.config/nvim/init.lua`
- **Lines**: 37–48, 86–111
- **Severity**: SUGGESTION

~30 lines of commented-out old `lspconfig` API code. Remove it — git history preserves the old approach.

---

### 19. 💡 `mason.lua` — Config Redundancy

- **File**: `/home/freebird/.config/nvim/lua/plugins/mason.lua`
- **Lines**: 5–7
- **Severity**: SUGGESTION

Mason's `config` function is commented out, but `require("mason").setup()` is called from `init.lua`. Unify: either enable the config in the plugin spec, or remove the commented block.

---

### 20. 💡 `.gitignore` — Too Minimal

- **File**: `/home/freebird/.config/nvim/.gitignore`
- **Severity**: SUGGESTION

Only ignores `*.log`. Consider adding:
```
plugin/
lazy-lock.json
*.swp
*.swo
.DS_Store
```

(Whether to ignore `lazy-lock.json` is debatable — some prefer versioning it.)

---

### 21. 💡 `ui.lua` Line 13 — Lazy-Load Tag `version = "*"`

- **File**: `/home/freebird/.config/nvim/lua/plugins/ui.lua`
- **Line**: 14
- **Severity**: SUGGESTION

```lua
version = "*",
```

Using `"*"` (latest any-version tag) can lead to breaking changes on update. Consider pinning to a major version like `"v4.*"` for bufferline.

---

### 22. 💡 `editor.lua` — `vscode = true` on flash.nvim

- **File**: `/home/freebird/.config/nvim/lua/plugins/editor.lua`
- **Line**: 134
- **Severity**: SUGGESTION

```lua
vscode = true,
```

The `vscode` key is not a standard lazy.nvim field — it's a flash.nvim option. It should be inside `opts` instead. Currently it would be ignored by flash.nvim.

**Fix**: Move into `opts = { modes = { char = { enabled = false } } }` or whatever the flash.nvim equivalent setting is.

---

### 23. 💡 `coding.lua` — Unused `unpack` Pattern

- **File**: `/home/freebird/.config/nvim/lua/plugins/coding.lua`
- **Line**: 32
- **Severity**: SUGGESTION

```lua
unpack = unpack or table.unpack
```

This is a Lua 5.1 compatibility shim. Neovim uses LuaJIT (Lua 5.1), so `unpack` always exists. The `table.unpack` fallback is dead code. Can be simplified to:
```lua
local line, col = unpack(vim.api.nvim_win_get_cursor(0))
```

---

### 24. 💡 `lsp.lua` — Typo in Comment

- **File**: `/home/freebird/.config/nvim/lua/plugins/lsp.lua`
- **Line**: 32
- **Severity**: SUGGESTION

```lua
-- print(vim.inspect(vim.lsp.buf.list_workleader_folders()))
```

`workleader` should be `workspace`.

---

### 25. 💡 `luarc.json` — Redundant `neodev` Entry

- **File**: `/home/freebird/.config/nvim/lua/.luarc.json`
- **Lines**: 3, 18
- **Severity**: SUGGESTION

`neodev.nvim` paths appear twice — once for `types/stable` (line 3) and once for `lua` (line 18). This is unnecessary; the `types/stable` path alone should suffice.

---

## Architecture Notes

### Plugin Loading Dependencies

| Plugin | Load Trigger | Issue |
|--------|-------------|-------|
| mason.nvim | Eager (no lazy) | `config` commented out, setup called from init.lua |
| nvim-cmp | Eager (no lazy) | Requires nvim-autopairs before it loads |
| nvim-autopairs | `event = "VeryLazy"` | Race with nvim-cmp |
| null-ls.nvim | `event = "VeryLazy"` | ARCHIVED — migrate to none-ls.nvim |
| flash.nvim | `event = "VeryLazy"` | `vscode = true` misplaced |
| neo-tree | `keys = {"<leader>e"}` | ✅ Correct pattern |
| telescope | `keys = {multiple}` | ✅ Correct pattern |
| which-key | `event = "VeryLazy"` | ✅ Correct pattern |
| persistance.nvim | `event = "BufReadPre"` | ✅ Correct pattern |

### LSP Configuration Architecture

The config uses a **hybrid approach** that creates confusion:

1. `lazy.nvim` loads `lspconfig` plugin (lsp.lua:4) — but it's never used for server setup
2. `init.lua` uses the new Neovim 0.11 `vim.lsp.config` + `vim.lsp.enable` API (lines 50-85) — correct for ≥ 0.11
3. `init.lua` also calls `mason-lspconfig.setup()` (lines 27-36) — for installing servers
4. `lsp.lua` contains LSP keymaps (LspAttach), which is fine

**Recommendation**: Choose one approach and stick to it:
- **For Neovim ≥ 0.11**: Use `vim.lsp.config` + `vim.lsp.enable` ONLY. Remove `lspconfig` dependency. Move LSP server config into plugin specs or a dedicated file.
- **For Neovim < 0.11**: Use `lspconfig` + `mason-lspconfig`. Move all LSP server config (currently in init.lua) into `lsp.lua`.

---

## File Inventory

| File | Status | Lines | Issues |
|------|--------|-------|--------|
| `init.lua` | Active | 111 | 6 problems (vim.loop, LSP API, dead code, mixed concerns) |
| `lua/config/options.lua` | Active | 24 | 1 problem (debug print) |
| `lua/config/keymaps.lua` | Active | 21 | 1 problem (incomplete comment) |
| `lua/.luarc.json` | Active | 31 | 2 problems (wrong paths, duplicates) |
| `lua/plugins/init.lua` | Active | 41 | ✅ Clean |
| `lua/plugins/lsp.lua` | Active | 73 | 3 problems (null-ls archived, formatting_sync, typo) |
| `lua/plugins/coding.lua` | Active | 169 | 2 problems (race condition, dead code) |
| `lua/plugins/editor.lua` | Active | 174 | 1 problem (vscode misplacement) |
| `lua/plugins/ui.lua` | Active | 222 | 6 problems |
| `lua/plugins/git.lua` | Active | 46 | ✅ Clean (commented blocks are fine) |
| `lua/plugins/debug.lua` | Active | 110 | 1 problem (undefined get_args) |
| `lua/plugins/mason.lua` | Active | 9 | 1 problem (config redundancy) |
| `lua/plugins/treesitter.lua` | Active | 16 | ✅ Clean |
| `lua/plugins/markdown.lua` | Active | 11 | ✅ Clean |
| `lua/plugins/c_cpp.lua` | Active | 32 | ✅ Clean |
| `lua/plugins/todo.lua` | Active | 25 | 1 problem (dead old code) |
| `lua/plugins/uitl.lua` | Active | 25 | 1 problem (filename typo) |
| `lua/plugins/format.lua` | Dead | 46 | Replace or delete |
| `lazy-lock.json` | Active | 50 | 3 orphaned plugins |
| `.gitignore` | Active | 1 | Too minimal |

---

## Quick Fix Checklist

- [ ] Fix `.luarc.json` paths (`/home/lizhuohang/` → `/home/freebird/`)
- [ ] Remove 3 duplicate `${3rd}/luv/library` entries in `.luarc.json`
- [ ] Replace `null-ls.nvim` with `none-ls.nvim` in `lsp.lua`
- [ ] Replace `LazyVim.pick()` calls in `ui.lua` dashboard with telescope commands
- [ ] Fix incomplete `action = 'lua '` in `ui.lua:149`
- [ ] Define or remove `get_args` in `debug.lua:94`
- [ ] Remove `vim.lsp.buf.formatting_sync = nil` from `lsp.lua:14`
- [ ] Replace `vim.loop` with `vim.uv` in `init.lua:9`
- [ ] Remove debug `vim.print` statements (ui.lua:27, options.lua:12)
- [ ] Fix `dependencies` string → table in `ui.lua:16`
- [ ] Fix typo "Nexe" → "Next" in `ui.lua:23`
- [ ] Rename `uitl.lua` → `util.lua`
- [ ] Move `vscode = true` into `opts` for flash.nvim (editor.lua:134)
- [ ] Run `:Lazy clean` to remove orphaned plugins from lock file
- [ ] Remove dead file `format.lua` or uncomment it
- [ ] Decide: stick with `vim.lsp.config` (Neovim 0.11+) or switch to `lspconfig`

---

## Neovim Version Note

If running **Neovim < 0.11**:
- `vim.lsp.config` / `vim.lsp.enable` calls in `init.lua` will **silently fail** — no LSP servers will start.
- `vim.lsp.buf.formatting_sync = nil` will throw an error.
- Recommendation: use `lspconfig` + `mason-lspconfig` instead.

If running **Neovim ≥ 0.11**:
- The `vim.lsp.config` approach is correct and recommended.
- `vim.loop` → `vim.uv` is preferred.
- Remove the `lspconfig` dependency from `lsp.lua` since it's not used.

---

*Report generated by comprehensive manual analysis + automated exploration of all 20 files.*
