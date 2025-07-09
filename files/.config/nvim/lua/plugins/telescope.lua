return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.6", -- or branch = "0.1.x"
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make", cond = vim.fn.executable("make") == 1 },
	},
	cmd = "Telescope",
	keys = {
		{ "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
		{ "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
		{ "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
		{ "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help Tags" },
	},
	config = function()
		local telescope = require("telescope")
		telescope.setup({
			defaults = {
				layout_config = { prompt_position = "top" },
				sorting_strategy = "ascending",
				winblend = 10,
			},
			pickers = {
				find_files = {
					hidden = true,
				},
			},
		})

		-- Load extensions if available
		pcall(telescope.load_extension, "fzf")
	end,
}
