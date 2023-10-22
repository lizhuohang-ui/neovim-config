return {
	{
		event = "VeryLazy",
		"tpope/vim-fugitive",
		cmd = "Git",
	},
	{
		event = "VeryLazy",
		"lewis6991/gitsigns.nvim",
		config = function()
			require('gitsigns').setup()
		end,

	}
}
