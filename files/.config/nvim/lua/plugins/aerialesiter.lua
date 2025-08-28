return {
	"stevearc/aerial.nvim",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
	},
	event = "VeryLazy",
	keys = {
		{
			"<leader>a",
			function()
				require("aerial").toggle()
			end,
			desc = "Aerial - toggle",
		},
	},
	opts = {
		backends = { "lsp", "markdown", "treesitter" },
		-- open_automatic = true,
		layout = {
			default_direction = "left",
		},
	},
}