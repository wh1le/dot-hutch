return {
	"mikavilpas/yazi.nvim",
	version = "*",
	event = "VeryLazy",
	dependencies = {
		{ "nvim-lua/plenary.nvim", lazy = true },
	},
	keys = {
		{
			"<leader>e",
			mode = { "n", "v" },
			-- "<cmd>Yazi<cr>",
			"<cmd>Yazi cwd<cr>",
			desc = "Open yazi at the current file",
		},
	},
	opts = {
		keymaps = false,
		open_for_directories = false,
		-- keymaps = {},
	},
	init = function()
		vim.g.loaded_netrwPlugin = 1
	end,
}
