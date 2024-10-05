
local set = vim.o
set.number = true -- line number
set.scrolloff = 10
set.tabstop = 2
set.shiftwidth = 2
set.relativenumber = true -- relative line number
set.clipboard = "unnamedplus" -- access OS clipboard in neovim

-- after copy, highlight copy context
vim.api.nvim_create_autocmd({ "TextYankPost" }, {
	pattern = { "*" },
	callback = function()
		vim.highlight.on_yank({
			timeout = 300,
		})
	end,
})
