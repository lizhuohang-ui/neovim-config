return {
	{
		event = "VeryLazy",
		"tpope/vim-fugitive",
		cmd = "Git",
		config = function()
			vim.cmd.cnoreabbrev([[git Git]])
		end
	},
	{
		event = "VeryLazy",
		"lewis6991/gitsigns.nvim",
		config = function()
			require('gitsigns').setup()
		end,

	},
	{
		event = "VeryLazy",
		"tpope/vim-rhubarb"
	},
	{
		event = "VeryLazy",
		"rhysd/conflict-marker.vim"
	},
}
