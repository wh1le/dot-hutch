return {
	"williamboman/mason.nvim",
	enabled = true,
	config = function()
		require("mason").setup({
			ui = { border = "rounded", check_outdated_packages_on_open = false },
			PATH = "skip",
		})
	end,
}
