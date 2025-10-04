return {
	"mbrea-c/mbc-colorscheme.nvim",
	dependencies = {
		{ "mbrea-c/wal-colors.nvim" },
	},
	config = function()
		vim.cmd([[colorscheme mbc]])
	end,
	priority = 1000,
}
