return {
	{
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
	},
	{
		"isakbm/gitgraph.nvim",
		opts = {
			git_cmd = "git",
			symbols = {
				merge_commit = "M",
				commit = "*",
			},
			format = {
				timestamp = "%H:%M:%S %d-%m-%Y",
				fields = { "hash", "timestamp", "author", "branch_name", "tag" },
			},
			hooks = {
				on_select_commit = function(commit)
					print("selected commit:", commit.hash)
				end,
				on_select_range_commit = function(from, to)
					print("selected range:", from.hash, to.hash)
				end,
			},
		},
		keys = {
			{
				"<leader>gl",
				function()
					require("gitgraph").draw({}, { all = true, max_count = 5000 })
				end,
				desc = "GitGraph - Draw",
			},
		},
	},
}
