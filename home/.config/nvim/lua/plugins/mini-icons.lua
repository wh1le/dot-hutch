return {
	"echasnovski/mini.icons",
	lazy = true,
	init = function()
		package.preload["nvim-web-devicons"] = function()
			require("mini.icons").mock_nvim_web_devicons()
			return package.loaded["nvim-web-devicons"]
		end
	end,
	config = function()
		require("mini.icons").setup()
		require("mini.icons").mock_nvim_web_devicons()
	end,
}
