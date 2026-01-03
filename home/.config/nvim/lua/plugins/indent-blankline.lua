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
		-- Clear backgrounds before setup
		vim.api.nvim_set_hl(0, "IblIndent", { fg = "#444444", bg = "NONE" })
		vim.api.nvim_set_hl(0, "IblWhitespace", { bg = "NONE" })
		vim.api.nvim_set_hl(0, "@ibl.indent.char.1", { fg = "#444444", bg = "NONE" })
		vim.api.nvim_set_hl(0, "@ibl.whitespace.char.1", { bg = "NONE" })

		require("ibl").setup(opts)
	end,
}
