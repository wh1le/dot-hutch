return {
	"lukas-reineke/indent-blankline.nvim",
	main = "ibl",
	event = "VeryLazy",
	opts = {
		whitespace = {
			remove_blankline_trail = true,
		},
		indent = {
			char = "⋅",
			tab_char = "⋅",
			-- char = "•",
			-- tab_char = "•"
		},
		scope = {
			enabled = false,
		},
	},
}
