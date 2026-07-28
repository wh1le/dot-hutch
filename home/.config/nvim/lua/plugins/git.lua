return {
	{
		"tpope/vim-fugitive",
		init = function()
			-- Diff* highlight colors moved to config/colors.lua

			vim.api.nvim_create_autocmd("FileType", {
				pattern = "fugitive",
				callback = function(ev)
					vim.keymap.set("n", "<CR>", "gf", { buffer = ev.buf, desc = "Open file in current window" })
				end,
			})
		end,
		keys = {
			{ "<leader>gs", "<cmd>Git<cr>", desc = "Git Status" },
			{ "<leader>gd", "<cmd>Gdiffsplit<cr>", desc = "Git Diff" },
			{ "<leader>gb", "<cmd>Git blame<cr>", desc = "Git Blame" },
		},
	},
	{
		"sindrets/diffview.nvim",
		opts = {
			use_icons = false,
		},
	},
}
