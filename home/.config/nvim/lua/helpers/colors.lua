-- {
--     gray01 = "#fafafa",
--     gray02 = "#f5f5f5",
--     gray03 = "#f0f0f0",
--     gray04 = "#ebebeb",
--     gray05 = "#e0e0e0",
-- }

NM.colors = {
	pywal_colors = function()
		return require("pywal16.core").get_colors()
	end,

	lua_line_theme = function()
		local colors = NM.statusline.pywal_colors()

		return {
			normal = {
				a = { fg = colors.foreground, bg = colors.background },
				b = { fg = colors.foreground, bg = colors.background },
				c = { fg = colors.foreground, bg = colors.background },
			},
			insert = {
				a = { fg = colors.foreground, bg = colors.background },
				b = { fg = colors.foreground, bg = colors.background },
				c = { fg = colors.foreground, bg = colors.background },
			},
			visual = {
				a = { fg = colors.foreground, bg = colors.background },
				b = { fg = colors.foreground, bg = colors.background },
				c = { fg = colors.foreground, bg = colors.background },
			},
			replace = {
				a = { fg = colors.foreground, bg = colors.background },
				b = { fg = colors.foreground, bg = colors.background },
				c = { fg = colors.foreground, bg = colors.background },
			},
			command = {
				a = { fg = colors.foreground, bg = colors.background },
				b = { fg = colors.foreground, bg = colors.background },
				c = { fg = colors.foreground, bg = colors.background },
			},
			inactive = {
				a = { fg = colors.foreground, bg = colors.background },
				b = { fg = colors.foreground, bg = colors.background },
				c = { fg = colors.foreground, bg = colors.background },
			},
		}
	end,
}
