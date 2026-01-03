-- return {
--   "folke/twilight.nvim",
--   dependencies = { "nvim-treesitter/nvim-treesitter" },
--   opts = {
--     dimming = {
--       alpha = 0.25, -- amount of dimming
--       -- we try to get the foreground from the highlight groups or fallback color
--       color = { "#ffffff", "#000000" },
--       term_bg = "#ffffff", -- if guibg=NONE, this will be used to calculate text color
--       -- inactive = true, -- when true, other windows will be fully dimmed (unless they contain the same buffer)
--     },
--     context = 15, -- amount of lines we will try to show around the current line
--     -- treesitter = true,
--     -- expand = { -- for treesitter, we we always try to expand to the top-most ancestor with these types
--     --   "function",
--     --   "method",
--     --   "table",
--     --   "if_statement",
--     -- },
--     -- exclude = {}, -- exclude these filetypes
--   }
-- }

return {
	"folke/twilight.nvim",
	dependencies = { "nvim-treesitter/nvim-treesitter" },
	cmd = "Twilight",
	opts = {
		dimming = {
			alpha = 0.3,
			color = { "#808080", "#fbfbfb" },
			term_bg = "NONE",
			inactive = false,
		},
		context = 0,
		treesitter = true,
		expand = {
			"function_definition",
			"function",
			"method",
		},
		exclude = {
			"aerial",
			"oil",
		}, -- exclude these filetypes
	},
}
