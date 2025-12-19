return {
	"nvim-lualine/lualine.nvim",
	lazy = false,
	-- dependencies = { "neovim/nvim-lspconfig", },
	config = function()
		require("lualine").setup(NM.lualine_config.get())
	end,
}
