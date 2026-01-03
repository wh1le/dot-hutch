return {
	"mikavilpas/yazi.nvim",
	version = "*",
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
	},
	init = function()
		vim.g.loaded_netrwPlugin = 1
	end,
}
