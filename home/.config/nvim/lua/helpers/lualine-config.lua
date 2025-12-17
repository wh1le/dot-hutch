NM.lualine_config = {
	get = function()
		return {
			options = {
				theme = "16color",
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
						color = { fg = 0, gui = "bold" },
					},
				},
				lualine_b = {},
				lualine_c = {
					{ "filetype", icon_only = true, padding = { left = 1, right = 0 } },
					{ NM.statusline.current_file_name },
				},
				lualine_x = {},
				lualine_y = {
					{
						NM.statusline.diagnostic_summary,
						cond = function()
							return vim.fn.winwidth(0) > 60
						end,
					},
				},
				lualine_z = {
					{
						NM.statusline.lsp_state_icon,
						color = { bg = "none", gui = "bold" },
						separator = { left = "", right = "" },
					},
					{
						NM.statusline.total_lines,
						color = { fg = 0, gui = "bold" },
					},
				},
			},
			inactive_sections = {
				lualine_a = {
					{
						"mode",
						fmt = NM.statusline.current_mode,
					},
				},
				lualine_b = {},
				lualine_c = {
					{ "filetype", icon_only = true, padding = { left = 1, right = 0 } },
					{ NM.statusline.current_file_name },
				},
				lualine_z = {
					{
						NM.statusline.total_lines,
						separator = { left = "" },
					},
				},
				lualine_x = {},
				lualine_y = {},
			},
		}
	end,
}
