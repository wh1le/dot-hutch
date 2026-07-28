return {
	"coder/claudecode.nvim",
	dependencies = { "folke/snacks.nvim" },
	cmd = {
		"ClaudeCode",
		"ClaudeCodeFocus",
		"ClaudeCodeSelectModel",
		"ClaudeCodeAdd",
		"ClaudeCodeSend",
		"ClaudeCodeTreeAdd",
		"ClaudeCodeDiffAccept",
		"ClaudeCodeDiffDeny",
	},
	config = true,
	keys = {
		{ "<leader>A", "", desc = "+claude" },

		-- Session
		{ "<leader>Ac", "<cmd>ClaudeCode<cr>", desc = "Toggle" },
		{ "<leader>Af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus" },
		{ "<leader>Ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume" },
		{ "<leader>AC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue" },
		{ "<leader>Am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select model" },

		-- Context
		{ "<leader>Ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add buffer" },
		{ "<leader>As", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send selection" },
		{
			"<leader>At",
			"<cmd>ClaudeCodeTreeAdd<cr>",
			desc = "Add file from tree",
			ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw" },
		},

		-- Diff
		{ "<leader>Aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
		{ "<leader>Ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
	},
}