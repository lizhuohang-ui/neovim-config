return {
	-- colorscheme config
	{
		'shaunsingh/nord.nvim',
		lazy = false,
		priority = 1000,
		config = function()
			vim.cmd([[colorscheme nord]])
		end,
	},
	-- bufferline config
	{
		'akinsho/bufferline.nvim',
		version = "*",
		event = "VeryLazy",
		dependencies = { 'nvim-tree/nvim-web-devicons' },
		keys = {
			{ "<leader>bc", "<Cmd>bdelete<CR>",               desc = "close current buffer" },
			{ "<leader>br", "<Cmd>BufferLineCloseRight<CR>",  desc = "close buffer to the right" },
			{ "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>",   desc = "close buffer to the left" },
			{ "<leader>bo", "<Cmd>BufferLineCloseOthers<CR>", desc = "close other buffers" },
			{ "<S-h>",      "<Cmd>BufferLineCyclePrev<CR>",   desc = "Prev buffer" },
			{ "<S-l>",      "<Cmd>BufferLineCycleNext<CR>",   desc = "Next buffer" },
		},
		config = function()
			vim.opt.termguicolors = true
			require("bufferline").setup {
				options = {
					mode = "buffers",
					numbers = "buffer_id",
					diagnostics = "nvim_lsp",
					offsets = {
						{
							filetype = "neo-tree",
							text = "File Explorer",
							highlight = "Directory",
							text_align = "left"
						}
					}
				}
			}
		end
	},
	-- statusline config
	{
		'nvim-lualine/lualine.nvim',
		event = "VeryLazy",
		dependencies = { 'nvim-tree/nvim-web-devicons' },
		config = function()
			require('lualine').setup {
				options = {
					icons_enabled = true,
					theme = 'auto',
					component_separators = { left = '', right = '' },
					section_separators = { left = '', right = '' },
					disabled_filetypes = {
						statusline = {},
						winbar = {},
					},
					ignore_focus = {},
					always_divide_middle = true,
					globalstatus = false,
					refresh = {
						statusline = 1000,
						tabline = 1000,
						winbar = 1000,
					}
				},
				sections = {
					lualine_a = { 'mode' },
					lualine_b = { 'branch', 'diff', 'diagnostics' },
					lualine_c = { 'filename' },
					lualine_x = { 'encoding', 'fileformat', 'filetype' },
					lualine_y = { 'progress' },
					lualine_z = { 'location' }
				},
				inactive_sections = {
					lualine_a = {},
					lualine_b = {},
					lualine_c = { 'filename' },
					lualine_x = { 'location' },
					lualine_y = {},
					lualine_z = {}
				},
				tabline = {},
				winbar = {},
				inactive_winbar = {},
				extensions = {}
			}
		end
	},
	-- indentation guides config
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		---@module "ibl"
		---@type ibl.config
		opts = {},
		config = function()
			require("ibl").setup({
				exclude = {
					filetypes = {
						'help',
						'dashboard',
						'NvimTree',
						'neo-tree',
					},
					buftypes = {
						'nofile',
						'terminal',
					},
				},
			}
			)
		end,
	},
	{
		'nvimdev/dashboard-nvim',
		event = 'VimEnter',
		dependencies = { { 'nvim-tree/nvim-web-devicons' } },
		opts = {
			-- config
			theme = "doom",
			-- hide = {
			-- 	statusline = false
			-- },
			config = {
				header = {
					'',
					'',
					'',
					'',
					'███████╗██████╗ ███████╗███████╗██████╗ ██╗██████╗ ██████╗ ',
					'██╔════╝██╔══██╗██╔════╝██╔════╝██╔══██╗██║██╔══██╗██╔══██╗',
					'█████╗  ██████╔╝█████╗  █████╗  ██████╔╝██║██████╔╝██║  ██║',
					'██╔══╝  ██╔══██╗██╔══╝  ██╔══╝  ██╔══██╗██║██╔══██╗██║  ██║',
					'██║     ██║  ██║███████╗███████╗██████╔╝██║██║  ██║██████╔╝',
					'╚═╝     ╚═╝  ╚═╝╚══════╝╚══════╝╚═════╝ ╚═╝╚═╝  ╚═╝╚═════╝ ',
					'',
					'',
					'',
					'',
				},
				center = {
					{ action = "Telescope find_files", desc = " Find File", icon = " ", key = "f" },
					{ action = "ene | startinsert", desc = " New File", icon = " ", key = "n" },
					{ action = "Telescope oldfiles", desc = " Recent Files", icon = " ", key = "r" },
					{ action = "Telescope live_grep", desc = " Find Text", icon = " ", key = "g" },
					{
						action = function()
							require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("config") })
						end,
						desc = " Config",
						icon = " ",
						key = "c"
					},
					{ action = 'lua require("persistence").load()', desc = " Restore Session", icon = " ", key = "s" },
					{ action = "Lazy", desc = " Lazy", icon = "󰒲 ", key = "l" },
					{ action = function() vim.api.nvim_input("<cmd>qa<cr>") end, desc = " Quit", icon = " ", key = "q" },
				},
				footer = function()
					local stats = require("lazy").stats()
					local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
					return { "⚡ Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms" }
				end,
				vertical_center = false
			}
		},
		config = function(_, opts)
			require('dashboard').setup(opts)
		end,
	},
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		opts = {
			-- add any options here
		},
		dependencies = {
			-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
			"MunifTanjim/nui.nvim",
			-- OPTIONAL:
			--   `nvim-notify` is only needed, if you want to use the notification view.
			--   If not available, we use `mini` as the fallback
			"rcarriga/nvim-notify",
		},
		config = function()
			require("noice").setup({
				lsp = {
					-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
					override = {
						["vim.lsp.util.convert_input_to_markdown_lines"] = true,
						["vim.lsp.util.stylize_markdown"] = true,
						["cmp.entry.get_documentation"] = true,
					},
				},
				-- you can enable a preset for easier configuration
				presets = {
					bottom_search = true,    -- use a classic bottom cmdline for search
					command_palette = true,  -- position the cmdline and popupmenu together
					long_message_to_split = true, -- long messages will be sent to a split
					inc_rename = false,      -- enables an input dialog for inc-rename.nvim
					lsp_doc_border = false,  -- add a border to hover docs and signature help
				},
			})
		end
	},
	{
		"echasnovski/mini.icons",
		lazy = true,
		opts = {
			file = {
				[".keep"] = { glyph = "󰊢", hl = "MiniIconsGrey" },
				["devcontainer.json"] = { glyph = "", hl = "MiniIconsAzure" },
			},
			filetype = {
				dotenv = { glyph = "", hl = "MiniIconsYellow" },
			},
		},
		init = function()
			package.preload["nvim-web-devicons"] = function()
				require("mini.icons").mock_nvim_web_devicons()
				return package.loaded["nvim-web-devicons"]
			end
		end,
	}
}
