-- https://github.com/davidgranstrom/scnvim
return {
	"davidgranstrom/scnvim",
	ft = "supercollider",
	config = function()
		local scnvim = require("scnvim")
		local map = scnvim.map
		local map_expr = scnvim.map_expr
		scnvim.setup({
			-- your config here
		})
	end,
}
