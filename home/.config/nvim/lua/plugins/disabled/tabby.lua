-- https://github.com/nanozuki/tabby.nvim

return {
	"nanozuki/tabby.nvim",
	enabled = false,
	config = function()
		local theme = {
			fill = "TabLineFill",
			head = "TabLine",
			current_tab = "TabLineSel",
			tab = "TabLine",
			win = "TabLine",
			tail = "TabLine",
		}

		require("tabby").setup({
			line = function(line)
				return {
					{ line.sep("", theme.head, theme.fill) },
					line.tabs().foreach(function(tab)
						local hl = tab.is_current() and theme.current_tab or theme.tab
						return {
							line.sep("", hl, theme.fill),
							tab.number(),
							tab.name(),
							line.sep("", hl, theme.fill),
							hl = hl,
							margin = " ",
						}
					end),
					hl = theme.fill,
				}
			end,
			option = {},
		})

		vim.api.nvim_create_autocmd("VimEnter", {
			callback = function()
				vim.cmd([[Tabby rename_tab λ ]])
			end,
		})
	end,
}
