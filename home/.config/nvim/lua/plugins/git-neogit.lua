-- return {
-- 	"NeogitOrg/neogit",
-- 	dependencies = {
-- 		"nvim-lua/plenary.nvim",
-- 		"sindrets/diffview.nvim",
-- 	},
-- 	config = function()
-- 		require("neogit").setup({
-- 			integrations = {
-- 				telescope = true, -- just “on / off”
-- 				diffview = true, -- idem
-- 			},
-- 		})
-- 	end,
-- }

return {
	"NeogitOrg/neogit",
	dependencies = { "nvim-lua/plenary.nvim" }, -- keep it minimal for now
	config = function()
		require("neogit").setup({}) -- vanilla; no integrations, no booleans
	end,
	-- ↓ optional but avoids lazy-loading weirdness while debugging
	cmd = "Neogit",
}
