return {
	"stevearc/oil.nvim",
	opts = {
		default_file_explorer = true,
		columns = {},
		use_default_keymaps = false,
		view_options = { show_hidden = true },
		keymaps = {
			["<CR>"] = { "actions.select", mode = "n" },
		},
	},
	lazy = false,
	keys = {
		{
			"-",
			function()
				require("oil").open()
			end,
			desc = "Oil: Open parent dir",
			mode = "n",
			silent = true,
		},
	},
	init = function()
		-- vim.g.loaded_netrw = 1
		-- vim.g.loaded_netrwPlugin = 1
	end,
}
