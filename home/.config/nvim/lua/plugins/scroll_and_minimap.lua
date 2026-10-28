-- https://github.com/mihovilrak/scroll.nvim

return {
	"mihovilrak/scroll.nvim",
	opts = {
		minimap = { enabled = true, cursor = false },
		explorer = true,
		marks = {
			git = false,
			diagnostics = { severity = { min = vim.diagnostic.severity.WARN } },
		},
		vertical = {
			enabled = true,
			width = 1, -- track width in columns
			char = "█", -- thumb glyph
			track_char = "│", -- track glyph; " " for an invisible track
		},
	},
}
