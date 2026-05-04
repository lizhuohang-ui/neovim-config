return {
	-- GitHub Copilot
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		config = function()
			require("copilot").setup({
				suggestion = {
					enabled = true,
					auto_trigger = true,
					keymap = {
						accept = "<M-l>",
						accept_word = false,
						accept_line = false,
						next = "<M-]>",
						prev = "<M-[>",
						dismiss = "<C-]>",
					},
				},
				panel = {
					enabled = true,
					auto_refresh = false,
					keymap = {
						jump_prev = "[[",
						jump_next = "]]",
						accept = "<CR>",
						refresh = "gr",
						open = "<M-CR>",
					},
					layout = {
						position = "bottom",
						ratio = 0.4,
					},
				},
				filetypes = {
					yaml = false,
					markdown = false,
					help = false,
					gitcommit = false,
					gitrebase = false,
					hgcommit = false,
					svn = false,
					cvs = false,
					["."] = false,
				},
			})
		end,
	},
	-- OpenCode AI agent integration
	-- {
	-- 	"sudo-tee/opencode.nvim",
	-- 	event = "VeryLazy",
	-- 	dependencies = {
	-- 		"nvim-lua/plenary.nvim",
	-- 		{
	-- 			"MeanderingProgrammer/render-markdown.nvim",
	-- 			opts = {
	-- 				anti_conceal = { enabled = false },
	-- 				file_types = { 'markdown', 'opencode_output' },
	-- 			},
	-- 			ft = { 'markdown', 'Avante', 'copilot-chat', 'opencode_output' },
	-- 		},
	-- 	},
	-- 	config = function()
	-- 		require("opencode").setup({
	-- 			-- OpenCode server configuration
	-- 			url = nil,
	-- 			port = 'auto',
	-- 			timeout = 5,
	-- 			auto_kill = true,
	-- 			-- UI configuration
	-- 			ui = {
	-- 				window_width = 0.35,
	-- 				window_height = 0.8,
	-- 			},
	-- 			-- Keymaps
	-- 			keys = {
	-- 				{ '<leader>oo', 'toggle', desc = 'Toggle OpenCode' },
	-- 				{ '<leader>on', 'new_session', desc = 'New OpenCode session' },
	-- 				{ '<leader>or', 'run', desc = 'Run OpenCode prompt' },
	-- 			},
	-- 		})
	-- 	end,
	-- },
}
