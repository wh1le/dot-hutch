return {
	"mbrea-c/mbc-colorscheme.nvim",
	enabled = false,
	dependencies = {
		{ "mbrea-c/wal-colors.nvim" },
	},
	config = function()
		vim.cmd([[colorscheme mbc]])
	end,
	priority = 1000,
}
