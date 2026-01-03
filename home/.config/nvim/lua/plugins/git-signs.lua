return {
	"lewis6991/gitsigns.nvim",
	cmd = { "Gitsigns" },
	opts = {
		signcolumn = false,
		numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
		linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
		word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
		watch_gitdir = {
			follow_files = true,
		},
	},
}
