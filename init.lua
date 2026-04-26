vim.g.mapleader = " " -- Make sure to set `mapleader` before lazy so your mappings are correct
vim.g.mkdp_browser = "chromium"
-- neovim option configuration
require("config.options")
-- keybindings
require("config.keymaps")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins")


-- lsp config
require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installed = {
		"lua_ls",
		"pyright",
		"clangd",
		"verible",
	},
	automatic_installation = true,
}
)
-- local lspconfig = require('lspconfig')
-- require("neodev").setup({
-- 	-- add any options here, or leave empty to use the default settings
-- })

-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
-- require('lspconfig')['<YOUR_LSP_SERVER>'].setup {
--	capabilities = capabilities
--}
--
vim.lsp.config.lua_ls = {
    capabilities = capabilities,
    settings = {
        Lua = {
            runtime = { version = "LuaJIT" },
            diagnostics = {
                globals = { "vim" },
            },
        },
    },
}
vim.lsp.enable("lua_ls")

vim.lsp.config.pyright = {
    capabilities = capabilities,
}

vim.lsp.enable("pyright")

vim.lsp.config.clangd = {
    capabilities = capabilities,
}

vim.lsp.enable("clangd")

vim.lsp.config.grammarly = {
    capabilities = capabilities,
}

vim.lsp.enable("grammarly")

vim.lsp.config.verible = {
    capabilities = capabilities,
}

vim.lsp.enable("verible")
-- require("lspconfig").lua_ls.setup {
-- 	capabilities = capabilities,
-- 	settings = {
-- 		Lua = {
-- 			runtime = {
-- 				version = "LuaJIT"
-- 			}
-- 		}
-- 	}
-- }
--
-- require("lspconfig").pyright.setup {
-- 	capabilities = capabilities
-- }
--
-- require("lspconfig").clangd.setup {
-- 	capabilities = capabilities
-- }
--
-- require("lspconfig")['grammarly'].setup {
-- 	capabilities = capabilities
-- }
--
-- require("lspconfig").verible.setup {
-- 	capabilities = capabilities
-- }
