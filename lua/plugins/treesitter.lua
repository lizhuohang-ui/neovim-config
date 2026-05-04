local install_dir = vim.fn.stdpath("data") .. "/site"
local parsers = {
	"c",
	"cpp",
	"lua",
	"vim",
	"vimdoc",
	"markdown",
	"markdown_inline",
	"python",
	"bash",
	"json",
	"query",
}
local filetypes = {
	"c",
	"cpp",
	"lua",
	"vim",
	"help",
	"markdown",
	"python",
	"sh",
	"bash",
	"json",
	"jsonc",
}

return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false,
		build = function()
			local treesitter = require("nvim-treesitter")

			treesitter.setup({ install_dir = install_dir })
			treesitter.install(parsers):wait(300000)
			treesitter.update(parsers):wait(300000)
		end,
		config = function()
			local treesitter = require("nvim-treesitter")

			treesitter.setup({
				install_dir = install_dir,
			})

			vim.treesitter.language.register("bash", { "sh", "bash" })

			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("UserTreesitter", { clear = true }),
				pattern = filetypes,
				callback = function()
					if pcall(vim.treesitter.start) then
						vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
					end
				end,
			})
		end
	},
}
