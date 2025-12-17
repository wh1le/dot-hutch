return {
	"rbong/vim-flog",
	lazy = true,
	cmd = { "Flog", "Flogsplit", "Floggit" },
	dependencies = { "tpope/vim-fugitive" },
	keys = {
		{ "<leader>gl", "<cmd>Flog<cr>", desc = "Git log (Flog)" },
		{ "<leader>gL", "<cmd>Flogsplit<cr>", desc = "Git log split" },
	},
}
