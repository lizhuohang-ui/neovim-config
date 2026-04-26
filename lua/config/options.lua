local set = vim.opt
set.number = true -- line number
set.scrolloff = 10
set.tabstop = 2
set.shiftwidth = 2
set.relativenumber = true     -- relative line number
set.clipboard = "unnamedplus" -- access OS clipboard in neovim
set.wrap = false -- disable line wrap

-- neovide configs
if vim.g.neovide then
	vim.print(vim.g.neovide_version)
	vim.g.neovide_transparency = 0.8
end

-- after copy, highlight copy context
vim.api.nvim_create_autocmd({ "TextYankPost" }, {
	pattern = { "*" },
	callback = function()
		vim.highlight.on_yank({
			timeout = 300,
		})
	end,
})
