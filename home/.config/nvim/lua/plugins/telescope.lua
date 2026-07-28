-- asfasdf

return {
	"nvim-telescope/telescope.nvim",
	version = "*",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make", cond = vim.fn.executable("make") == 1 },
		"nvim-telescope/telescope-live-grep-args.nvim",
	},
	cmd = "Telescope",
	keys = {
		{
			"<leader>f",
			function()
				local builtin = require("telescope.builtin")
				if not pcall(builtin.git_files, {
					show_untracked = true,
					use_git_root = false,
				}) then
					builtin.find_files()
				end
			end,
			desc = "Find Files",
		},
		{
			"<leader>F",
			function()
				require("telescope.builtin").find_files({
					hidden = true,
					no_ignore = true,
					cwd = vim.fn.getcwd(),
					use_git_root = false,
				})
			end,
			desc = "Find Files (Global)",
		},
		{
			"<leader>s",
			function()
				require("telescope").extensions.live_grep_args.live_grep_args({
					auto_quoting = true,
					cwd = vim.fn.getcwd(),
					use_git_root = false,
				})
			end,
			desc = "Live Grep",
		},
		{
			"<leader>S",
			function()
				require("telescope").extensions.live_grep_args.live_grep_args({
					hidden = true,
					no_ignore = true,
					auto_quoting = true,
					cwd = vim.fn.getcwd(),
					use_git_root = false,
				})
			end,
			desc = "Live Grep (Global)",
		},
		{ "<leader>b", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
	},
	config = function()
		vim.env.RIPGREP_CONFIG_PATH = vim.fn.expand("~/.config/ripgrep/config")
		local telescope = require("telescope")
		local actions = require("telescope.actions")
		telescope.setup({
			defaults = {
				layout_strategy = "bottom_pane",
				layout_config = {
					height = 0.4,
					prompt_position = "bottom",
				},
				sorting_strategy = "descending",
				border = true,
				winblend = 0,
				previewer = true,
				mappings = {
					i = {
						["<Esc>"] = actions.close,
						["<C-a>"] = actions.smart_send_to_qflist + actions.open_qflist,
					},
				},
			},
			pickers = {
				find_files = {
					hidden = true,
					file_ignore_patterns = { ".git/", ".gems/", ".direnv/" },
					previewer = false,
				},
				live_grep = {
					layout_strategy = "vertical",
					layout_config = {
						width = 0.95,
						height = 0.95,
						prompt_position = "bottom",
						preview_height = 0.3,
						mirror = true,
					},
				},
				grep_string = {
					layout_strategy = "vertical",
					layout_config = {
						width = 0.95,
						height = 0.95,
						prompt_position = "bottom",
						preview_height = 0.3,
						mirror = true,
					},
				},
			},
		})

		pcall(telescope.load_extension, "fzf")
		pcall(telescope.load_extension, "live_grep_args")
	end,
}
