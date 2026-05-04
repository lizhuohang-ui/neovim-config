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
						source = "filesystem",
						position = "left",
					})
				end,
				desc = "Explorer NeoTree",
			},
			{
				"<leader>E",
				function()
					local reveal_file = vim.fn.expand("%:p")
					if reveal_file == "" or vim.uv.fs_stat(reveal_file) == nil then
						reveal_file = vim.fn.getcwd()
					end

					require("neo-tree.command").execute({
						action = "focus",
						source = "filesystem",
						position = "left",
						reveal_file = reveal_file,
						reveal_force_cwd = true,
					})
				end,
				desc = "Explorer NeoTree (current file)",
			},
		},
		opts = {
			sources = { "filesystem", "buffers", "git_status" },
			source_selector = {
				winbar = true,
				sources = {
					{ source = "filesystem", display_name = " 󰉓 Files " },
					{ source = "buffers", display_name = " 󰈚 Buffers " },
					{ source = "git_status", display_name = " 󰊢 Git " },
				},
			},
			open_file_do_not_replace_types = { "terminal", "Trouble", "trouble", "qf", "Outline" },
			filesystem = {
				bind_to_cwd = false,
				follow_current_file = { enabled = true },
				use_libuv_file_watcher = true,
				hijack_netrw_behavior = "open_default",
				filtered_items = {
					visible = true,
					hide_by_name = {},
					never_show = {},
					never_show_by_pattern = {},
				},
			},
			window = {
				mappings = {
					["l"] = "open",
					["h"] = "close_node",
					["<space>"] = "none",
					["Y"] = {
						function(state)
							local node = state.tree:get_node()
							local path = node:get_id()
							vim.fn.setreg("+", path, "c")
						end,
						desc = "Copy Path to Clipboard",
					},
					["P"] = { "toggle_preview", config = { use_float = false } },
					["O"] = {
						function(state)
							local node = state.tree:get_node()
							local path = node.path or node:get_id()
							if path then
								vim.ui.open(path)
							end
						end,
						desc = "Open with System Application",
					},
				},
			},
			default_component_configs = {
				indent = {
					with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
					expander_collapsed = "",
					expander_expanded = "",
					expander_highlight = "NeoTreeExpander",
				},
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
		},
		config = function(_, opts)
			require("neo-tree").setup(opts)
		end,
	},
	-- file finder
	{
		'nvim-telescope/telescope.nvim',
		tag = '0.1.8',
		cmd = "Telescope",
		dependencies = { 'nvim-lua/plenary.nvim' },
		keys = {
			{ "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "find files" },
			{ "<leader>fo", "<cmd>Telescope oldfiles<cr>",   desc = "find oldfiles" },
			{ "<leader>fr", "<cmd>Telescope resume<cr>",     desc = "resume files" },
			{ "<leader>fg", "<cmd>Telescope live_grep<cr>",  desc = "grep files" },
			{ "<leader>fh", "<cmd>Telescope help_tags<cr>",  desc = "help tags" },
		},
		config = function()
			local actions = require("telescope.actions")
			require("telescope").setup {
				defaults = {
					preview = {
						-- Telescope 0.1.8 still calls removed nvim-treesitter parser APIs
						-- with nvim-treesitter main on Neovim 0.12, so use regex fallback.
						treesitter = false,
					},
					mappings = {
						n = {
							["q"] = actions.close
						},
					},
				}
			}
		end
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
			preset = "helix",
			defaults = {},
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		},
		config = function(_, opts)
			local wk = require("which-key")
			wk.setup(opts)
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
