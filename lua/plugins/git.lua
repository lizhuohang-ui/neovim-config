return {

	"kdheepak/lazygit.nvim",
	lazy = true,
	cmd = {
		"LazyGit",
		"LazyGitConfig",
		"LazyGitCurrentFile",
		"LazyGitFilter",
		"LazyGitFilterCurrentFile",
	},
	-- optional for floating window border decoration
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	-- setting the keybinding for LazyGit with 'keys' is recommended in
	-- order to load the plugin when the command is run for the first time
	keys = {
		{ "<leader>g", "<cmd>LazyGit<cr>", desc = "LazyGit" }
	},

	-- {
	-- 	event = "VeryLazy",
	-- 	"tpope/vim-fugitive",
	-- 	cmd = "Git",
	-- 	config = function()
	-- 		vim.cmd.cnoreabbrev([[git Git]])
	-- 	end
	-- },
	-- {
	-- 	event = "VeryLazy",
	-- 	"lewis6991/gitsigns.nvim",
	-- 	config = function()
	-- 		require('gitsigns').setup()
	-- 	end,
	--
	-- },
	-- {
	-- 	event = "VeryLazy",
	-- 	"tpope/vim-rhubarb"
	-- },
	-- {
	-- 	event = "VeryLazy",
	-- 	"rhysd/conflict-marker.vim"
	-- },
}
