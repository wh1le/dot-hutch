return {
	"stevearc/oil.nvim",
	opts = {},
	config = function()
		require("oil").setup({
			default_file_explorer = true, -- override netrw
			view_options = {
				show_hidden = true,
			},
			keys = {
				{
					"-",
					function()
						require("oil").open()
					end,
					desc = "Oil: Open parent dir",
				},
			},
			keymaps = {
				["<C-h>"] = false, -- disable if you don’t want help popup
			},
		})
	end,
}
