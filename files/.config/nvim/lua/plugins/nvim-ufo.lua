return {
	"kevinhwang91/nvim-ufo",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = { "kevinhwang91/promise-async" },
	keys = {
		{
			"zR",
			function()
				require("ufo").openAllFolds()
			end,
			desc = "UFO: open all folds",
			mode = "n",
			silent = true,
		},
		{
			"zM",
			function()
				require("ufo").closeAllFolds()
			end,
			desc = "UFO: close all folds",
			mode = "n",
			silent = true,
		},
		{
			"zp",
			function()
				require("ufo").peekFoldedLinesUnderCursor()
			end,
			desc = "UFO: peek fold",
			mode = "n",
			silent = true,
		},
	},
	config = function()
		vim.o.foldcolumn = "1" -- show fold column
		vim.o.foldlevel = 99 -- high value to keep folds open by default
		vim.o.foldlevelstart = 99 -- start with all folds open
		vim.o.foldenable = true -- enable folding

		require("ufo").setup()
	end,
}
