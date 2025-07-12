return {
	"stevearc/oil.nvim",
	opts = {},
	keymaps = {
		--   key      action                     split-opts
		["<C-v>"] = { "actions.select", opts = { vertical = true } },
		["<C-s>"] = { "actions.select", opts = { horizontal = true } },
	},
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
		-- Disable `-` in Lazy window and others
		vim.api.nvim_create_autocmd("FileType", {
			pattern = { "lazy", "lazyterm", "aerial" },
			callback = function()
				vim.keymap.set("n", "-", "<nop>", { buffer = true })
			end,
		})
	end,
	config = function()
		require("oil").setup({
			default_file_explorer = true, -- override netrw
			view_options = {
				show_hidden = true,
			},
			keymaps = {
				--   key      action                     split-opts
				["<C-v>"] = { "actions.select", opts = { vertical = true } },
				["<C-s>"] = { "actions.select", opts = { horizontal = true } },
			},
		})
	end,
}
