return {
	"ibhagwan/fzf-lua",
  enabled = false,
	lazy = false,
	dependencies = { "echasnovski/mini.icons" },
	opts = {
		defaults = {
			previewer = false,
		},
		fzf_bin = "fzf",
		files = { fzf_opts = { ["--layout"] = "default" } }, -- show search on low pos
		winopts = {
			width = 1.0,
			height = 0.30,
			row = 0.95,
			col = 0.50,
			border = "rounded",
			fullscreen = false,
			treesitter = {
				enabled = false,
			},
			preview = {
				hidden = true,
			},
		},
		buffers = {
			sort_lastused = true,
		},
		keymap = {
			builtin = {
				["<C-f>"] = "preview-page-down",
				["<C-b>"] = "preview-page-up",
				["<C-q>"] = "toggle-all+accept",
			},
			fzf = {
				["ctrl-q"] = "toggle-all+accept",
			},
		},
		preview = {
			hidden = true,
		},
	},

	keys = {
		{ "<leader>f", "<cmd>FzfLua files<cr>", desc = "FZF: Files" },
		{ "<leader>sg", "<cmd>FzfLua live_grep<cr>", desc = "FZF: Live Grep" },
		{ "<leader>sw", "<cmd>FzfLua grep_cword<cr>", desc = "FZF: Grep word under cursor" },
		{
			"<leader>fG",
			function()
				require("fzf-lua").live_grep({
					no_ignore = true,
					hidden = true,
				})
			end,
			desc = "FZF: Live Grep (no ignore)",
		},
		-- { "<leader>ff", "<cmd>FzfLua files<cr>", desc = "FZF: Files" },
		-- { "<leader>fg", "<cmd>FzfLua live_grep<cr>", desc = "FZF: Live Grep" },
		-- { "<leader>fb", "<cmd>FzfLua buffers<cr>", desc = "FZF: Buffers" },
		-- { "<leader>fh", "<cmd>FzfLua help_tags<cr>", desc = "FZF: Help Tags" },
		-- { "<leader>fo", "<cmd>FzfLua oldfiles<cr>", desc = "FZF: Old Files" },
		-- { "<leader>fk", "<cmd>FzfLua keymaps<cr>", desc = "FZF: Keymaps" },
		-- { "<leader>fm", "<cmd>FzfLua marks<cr>", desc = "FZF: Marks" },
		-- { "<leader>fc", "<cmd>FzfLua commands<cr>", desc = "FZF: Commands" },
		-- { "<leader>ft", "<cmd>FzfLua tags<cr>", desc = "FZF: Tags" },
		-- { "<leader>fr", "<cmd>FzfLua resume<cr>", desc = "FZF: Resume Last Picker" },
	},
}
