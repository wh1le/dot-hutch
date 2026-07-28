return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	enabled = false,
	opts = {
		show_help = true,
		delay = function()
			return 5000
		end,
		plugins = {
			presets = {
				operators = false,
				motions = false,
				text_objects = false,
				windows = false,
				nav = false,
				z = false,
				g = false,
			},
		},
	},
}
