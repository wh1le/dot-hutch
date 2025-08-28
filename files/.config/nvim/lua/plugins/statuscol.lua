return {
	"luukvbaal/statuscol.nvim",
	event = "VeryLazy", -- load after startup
	config = function()
		require("statuscol").setup({
			relculright = true,
			segments = {
				{ text = { require("statuscol.builtin").foldfunc }, click = "v:lua.ScFa" },
				{ text = { "%s" }, click = "v:lua.ScSa" },
				{ text = { require("statuscol.builtin").lnumfunc, " " }, click = "v:lua.ScLa" },
			},
		})
	end,
}
