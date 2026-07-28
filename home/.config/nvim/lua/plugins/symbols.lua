return {
	"stevearc/aerial.nvim",
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
		backends = {
			["_"] = { "lsp", "treesitter" },
			markdown = { "treesitter", "lsp" },
		},
		filter_kind = {
			["_"] = { "Class", "Function", "Method" },
			markdown = false,
		},
		icons_enabled = true,
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
		close_automatic_events = {},
		highlight_closest = true,
		autojump = true,
	},
}
