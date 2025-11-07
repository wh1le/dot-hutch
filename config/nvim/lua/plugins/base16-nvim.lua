return {
	{
		"RRethy/base16-nvim",
		priority = 1000, -- load before other UI plugins
		lazy = false, -- colorscheme must load on startup
		enabled = false,
		config = function()
			vim.opt.termguicolors = true
			vim.opt.background = "dark"

			vim.cmd.colorscheme("base16-ashes")
		end,
	},
}
