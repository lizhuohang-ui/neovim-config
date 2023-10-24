return {
	{
		'nvim-telescope/telescope.nvim',
		tag = '0.1.4',
		dependencies = { 'nvim-lua/plenary.nvim' },
		keys = {
			{ "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "find files" },
			{ "<leader>fo", "<cmd>Telescope oldfiles<cr>",   desc = "find oldfiles" },
			{ "<leader>fr", "<cmd>Telescope resume<cr>",     desc = "resume files" },
			{ "<leader>fg", "<cmd>Telescope live_grep<cr>",  desc = "grep files" },
		},
	},
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		event = "VeryLazy",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
		},
		keys = {
			{
				"<leader>e",
				function()
					require("neo-tree.command").execute({
						toggle = true,
						position = "left",
					})
				end,
				desc = "Explorer NeoTree (root dir)"
			},
		},
	},
	{
		"windwp/nvim-autopairs",
		event = "VeryLazy",
		config = function()
			require("nvim-autopairs").setup({
				fast_wrap = {},
				disable_filetype = { "TelescopePrompt", "vim", "sh" },
			})
		end,
	},
	{
		"JoosepAlviste/nvim-ts-context-commentstring",
		lazy = true,
		opts = {
			enable_autocmd = false,
		},
	},
	{
		"echasnovski/mini.comment",
		event = "VeryLazy",
		opts = {
			options = {
				custom_commentstring = function()
					return require("ts_context_commentstring.internal").calculate_commentstring() or
					vim.bo.commentstring
				end,
			},
		},
	}
}
