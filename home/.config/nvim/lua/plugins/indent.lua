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
			highlight = "IblIndent",
			-- char = "•",
			-- tab_char = "•"
		},
		scope = {
			enabled = false,
		},
	},
	config = function(_, opts)
		-- Ibl* highlight colors moved to config/colors.lua
		require("ibl").setup(opts)
	end,
}
