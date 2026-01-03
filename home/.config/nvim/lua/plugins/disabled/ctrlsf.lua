return {
	{
		"dyng/ctrlsf.vim",
		enabled = false,
		-- lazy-load on the <leader>g hit
		keys = {
			{ "<leader>g", ":CtrlSF ", mode = "n", desc = "CtrlSF search", noremap = true },
		},

		-- globals must exist *before* the plugin starts
		init = function()
			vim.g.ctrlsf_auto_close = { normal = 0, compact = 0 }
			vim.g.ctrlsf_auto_focus = { at = "start" }
			vim.g.ctrlsf_context = "-B 1 -A 2"
			vim.g.ctrlsf_winsize = "45%"
		end,
	},
}
