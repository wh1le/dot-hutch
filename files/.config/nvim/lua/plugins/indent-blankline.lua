return {
	"lukas-reineke/indent-blankline.nvim",
	main = "ibl",
	event = "VeryLazy",
	opts = {
		indent = {
			char = "·",
			tab_char = "·",
		},
		scope = {
			enabled = true, -- включает подсветку текущего scope
			-- show_start = false,
			-- show_end = false,
			-- -- highlight = { "Function", "Label" }, -- можно накатить любой highlight group
		},
	},
}
