return {
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
		config = function()
			require("neo-tree").setup({
				enable_git_status = true,
				default_component_configs = {
					git_status = {
						symbols = {
							-- Change type
							added     = "✚",
							deleted   = "✖",
							modified  = "",
							renamed   = "󰁕",
							-- Status type
							untracked = "",
							ignored   = "",
							unstaged  = "󰄱",
							staged    = "",
							conflict  = "",
						}
					}
				}
			})
		end,
	},
	-- file finder
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
	-- search/repace in multiple files
	-- test code
	{
		"MagicDuck/grug-far.nvim",
		opts = { headerMaxWidth = 80 },
		cmd = "GrugFar",
		keys = {
			{
				"<leader>sr",
				function()
					local grug = require("grug-far")
					local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
					grug.open({
						transient = true,
						prefills = {
							filesFilter = ext and ext ~= "" and "*." .. ext or nil,
						},
					})
				end,
				mode = { "n", "v" },
				desc = "Search and Replace",
			},
		},
	},
	-- enhance search
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		vscode = true,
		opts = {},
		-- stylua: ignore
		keys = {
			{ "s",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
			{ "S",     mode = { "n", "o", "x" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
			{ "r",     mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
			{ "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
			{ "<c-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
		},
	},
	-- which key
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
		end,
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		},
		config = function()
			local wk = require("which-key")
			wk.add({
				{ "<leader>w",  group = "window" },
				{ "<leader>wv", "<c-w>v",                   desc = "vsplit window" },
				{ "<leader>ws", "<c-w>s",                   desc = "vsplit window" },
				{ "<leader>m",  group = "markdown" },
				{ "<leader>mp", "<cmd>MarkdownPreview<cr>", desc = "markdown preview" },
				{ "<leader>t",  "<cmd>TranslateW<cr>",      desc = "TranslateW" },
				{ "<leader>d",  group = "debug" },
			})
		end
	},
}
