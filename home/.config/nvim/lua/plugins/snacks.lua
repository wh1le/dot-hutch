return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	opts = {
		input = { enabled = true },
		notifier = { enabled = true },
		styles = {
			input = {
				relative = "cursor",
				row = 1,
				col = 0,
				width = 50,
			},
		},
	},
}
