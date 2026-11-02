-- https://github.com/mihovilrak/scroll.nvim

return {
	"mihovilrak/scroll.nvim",
	init = function()
		local function highlights()
			local normal = vim.api.nvim_get_hl(0, { name = "Normal", link = false })
			local comment = vim.api.nvim_get_hl(0, { name = "Comment", link = false })
			vim.api.nvim_set_hl(0, "ScrollTrack", { bg = normal.bg })
			vim.api.nvim_set_hl(0, "ScrollThumb", { fg = comment.fg })
			vim.api.nvim_set_hl(0, "ScrollThumbHover", { fg = comment.fg })
			vim.api.nvim_set_hl(0, "ScrollMinimap", { fg = comment.fg, bg = normal.bg })
			vim.api.nvim_set_hl(0, "ScrollMinimapViewport", { link = "CursorLine" })
		end
		highlights()
		vim.api.nvim_create_autocmd("ColorScheme", {
			group = vim.api.nvim_create_augroup("ScrollTheme", { clear = true }),
			callback = highlights,
		})
	end,
	config = function(_, opts)
		local function resize()
			local compact = vim.o.lines < 40 or vim.o.columns < 140
			local width = compact and 7 or 14
			if opts.minimap.width == width then
				return
			end
			opts.minimap.width = width
			opts.minimap.columns_per_dot = compact and 6 or 3
			require("scroll").setup(opts)
		end
		resize()
		vim.api.nvim_create_autocmd("VimResized", {
			group = vim.api.nvim_create_augroup("ScrollSize", { clear = true }),
			callback = resize,
		})
	end,
	opts = {
		minimap = { enabled = true, cursor = false, colors = false },
		explorer = true,
		marks = {
			git = false,
			diagnostics = { severity = { min = vim.diagnostic.severity.WARN } },
		},
		vertical = {
			char = "▏",
			track_char = " ",
		},
		horizontal = {
			char = "▁",
			track_char = " ",
		},
	},
}
