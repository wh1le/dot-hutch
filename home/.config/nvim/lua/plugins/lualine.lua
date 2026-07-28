NM.statusline = {
	current_mode = function()
		local m = vim.fn.mode()
		return (m == "n" and "N")
			or (m == "i" and "I")
			or (m == "V" and "V")
			or (m == "R" and "R")
			or (m == "c" and "C")
			or ""
	end,

	total_lines = function()
		local line = vim.api.nvim_win_get_cursor(0)[1]
		local total = vim.api.nvim_buf_line_count(0)
		return string.format("%d:%d", line, total)
	end,

	diagnostic_summary = function()
		local sev = vim.diagnostic.severity
		local e = #vim.diagnostic.get(0, { severity = sev.ERROR })
		local w = #vim.diagnostic.get(0, { severity = sev.WARN })

		local parts = {}
		if e > 0 then
			table.insert(parts, string.format("󰢱 %d", e))
		end
		if w > 0 then
			table.insert(parts, string.format(" %d", w))
		end

		if #parts == 0 then
			return ""
		end
		return table.concat(parts, " ")
	end,

	current_file_name = function()
		local rel = vim.fn.expand("%:.") -- path relative to cwd
		if rel == "" then
			return "[No File]"
		end

		local segs = vim.fn.split(rel, "/")
		local fname = segs[#segs]
		local dir_count = #segs - 1

		if dir_count >= 2 then
			return string.format("%s/%s/%s", segs[dir_count - 1], segs[dir_count], fname)
		elseif dir_count == 1 then
			return "./" .. rel
		else
			local cwd_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
			return cwd_name .. "/" .. fname
		end
	end,

	lsp = {
		_get_attached_servers = function()
			local attached = {}
			local ignore = { typos_lsp = true }
			local buf = vim.api.nvim_get_current_buf()

			for _, client in ipairs(vim.lsp.get_clients()) do
				if client.attached_buffers[buf] and not ignore[client.name] then
					table.insert(attached, client.name)
				end
			end

			return attached
		end,

		get_icon = function(attached)
			return #attached == 0 and "" or ""
		end,
	},

	lsp_state_icon = function()
		if not vim.bo.filetype or vim.bo.filetype == "" then
			return ""
		end
		return NM.statusline.lsp.get_icon(NM.statusline.lsp._get_attached_servers())
	end,
}

NM.lualine_config = {
	get = function()
		return {
			options = {
				theme = "auto",
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
						color = { gui = "bold" },
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

return {
	"nvim-lualine/lualine.nvim",
	lazy = false,
	-- dependencies = { "neovim/nvim-lspconfig", },
	config = function()
		require("lualine").setup(NM.lualine_config.get())
	end,
}
