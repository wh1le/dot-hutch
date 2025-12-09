NM.lualine_config = {
	get = function()
		theme = NM.colors.lua_line_theme()
		colors = NM.colors.pywal_colors()

		return {
			options = {
				theme = theme,

				disabled_filetypes = {
					statusline = {
						"aerial",
						"Trouble",
						"NvimTree",
					},
				},
				icons_enabled = true,
			},
			sections = {
				lualine_a = {
					{
						"mode",
						fmt = NM.statusline.current_mode,
						color = {
							fg = colors.background,
							bg = colors.color1,
						},
					},
				},
				lualine_b = {},
				lualine_c = {
					{
						"filetype",
						icon_only = true,
						padding = { left = 1, right = 0 },
					},
					{
						NM.statusline.current_file_name,
						color = {
							fg = colors.foreground,
							bg = colors.background,
							gui = "bold",
						},
					},
				},
				lualine_x = {},
				lualine_y = {
					{
						NM.statusline.diagnostic_summary,
						color = {
							gui = "bold",
							fg = colors.foreground,
							bg = colors.background,
						},
						cond = function()
							return vim.fn.winwidth(0) > 60
						end,
					},
				},
				lualine_z = {

					{
						NM.statusline.lsp_state_icon,
					},
					{
						NM.statusline.total_lines,
						color = {
							fg = colors.background,
							bg = colors.color1,
							gui = "bold",
						},
					},
				},
			},

			inactive_sections = {
				lualine_a = {
					{
						"mode",
						fmt = function()
							return " "
						end,
						color = {
							fg = colors.foreground,
							bg = colors.color8,
							gui = "NONE",
						},
					},
				},
				lualine_b = {},
				lualine_c = {
					{
						"filetype",
						icon_only = true,
						padding = { left = 1, right = 0 },
					},
					{
						NM.statusline.current_file_name,
						color = {
							fg = colors.color8,
							bg = colors.background,
							gui = "bold",
						},
					},
				},
				lualine_z = {
					{
						NM.statusline.total_lines,
						color = {
							fg = colors.background,
							bg = colors.color8,
							gui = "bold",
						},
					},
				},
				lualine_x = {},
				lualine_y = {},
			},
		}
	end,
}
