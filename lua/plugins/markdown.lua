return {
	{
		"MeanderingProgrammer/render-markdown.nvim",
		ft = { "markdown" },
		cmd = { "RenderMarkdown" },
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"echasnovski/mini.icons",
		},
		keys = {
			{ "<leader>mr", "<cmd>RenderMarkdown toggle<cr>", desc = "toggle markdown rendering" },
		},
		---@module "render-markdown"
		---@type render.md.UserConfig
		opts = {
			file_types = { "markdown" },
			html = { enabled = false },
			latex = { enabled = false },
			yaml = { enabled = false },
		},
	},
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		build = "cd app && yarn install",
		init = function()
			vim.g.mkdp_filetypes = { "markdown" }
		end,
		ft = { "markdown" },
	},
}
