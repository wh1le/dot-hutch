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
    backends = { "lsp", "treesitter", "markdown" },
    filter_kind = false,
    show_guides = true,
		open_automatic = false,
    highlight_on_jump = 300,
    manage_folds = true,
		layout = {
      min_width = 32,
      max_width = { 80, 0.2 },
      width = nil,
			default_direction = "right",
      resize_to_content = true,
		},
    -- preserve_equality = false,
    close_automatic_events = {},
    highlight_closest = true,
    autojump = true,
	},
}