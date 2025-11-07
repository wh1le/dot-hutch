return {
	"nvim-lualine/lualine.nvim",
	dependencies = {
		"neovim/nvim-lspconfig",
	},
	opts = {
		options = {
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
						fg = NM.statusline.colors.foregroundColor,
						bg = NM.statusline.colors.backgroundColor,
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
						fg = NM.statusline.colors.foregroundColor,
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
					},
					cond = function()
						return vim.fn.winwidth(0) > 60
					end,
				},
			},
			lualine_z = {
				{
					NM.statusline.total_lines,
					color = {
						fg = "gray",
						bg = "Black",
						gui = "bold",
					},
				},

				{
					NM.statusline.lsp_state_icon,
					color = {
						fg = "gray",
						bg = "Black",
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
						fg = "gray",
						bg = "#000000",
						gui = "NONE",
					},
				},
			},
			lualine_b = {},
			lualine_c = {
				{
					NM.statusline.current_file_name,
					colors = {
						fg = NM.statusline.colors.foregroundColor,
						-- bg = backgroundColor,
						gui = "bold",
					},
				},
			},
			lualine_z = {
				{
					NM.statusline.total_lines,
					color = {
						fg = "gray",
						bg = "Black",
						gui = "bold",
					},
				},
			},
			lualine_x = {},
			lualine_y = {},
		},
	},
}
