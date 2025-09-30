return {
	"nvim-lualine/lualine.nvim",
	opts = function(_, opts)
		opts = opts or {}
		opts.options = opts.options or {}
		opts.sections = opts.sections or {}

		local function vim_mode()
			local m = vim.fn.mode()

			local total = vim.api.nvim_buf_line_count(0)
			local pad = string.rep(" ", math.max(#tostring(total), 0))

			local res = (m == "n" and " N")
				or (m == "i" and " I")
				or (m == "V" and " V")
				or (m == "R" and " R")
				or (m == "c" and " C")
				or ""
			return pad .. res
		end

		local function branch_name()
			local gs = vim.b.gitsigns_status_dict
			local head = (gs and gs.head) or ""
			if head == "" and vim.fn.exists("*FugitiveHead") == 1 then
				head = vim.fn.FugitiveHead()
			end
			if head == "" then
				local f = io.popen("git rev-parse --abbrev-ref HEAD 2>/dev/null")
				if f then
					head = (f:read("*a") or ""):gsub("%s+", "")
					f:close()
				end
			end
			return head ~= "" and (" " .. head) or ""
		end

		local function total_lines()
			local line = vim.api.nvim_win_get_cursor(0)[1]
			local total = vim.api.nvim_buf_line_count(0)
			return string.format("%d:%d", line, total)
		end

		local function linter_status()
			local sev = vim.diagnostic.severity
			local e = #vim.diagnostic.get(0, { severity = sev.ERROR })
			local w = #vim.diagnostic.get(0, { severity = sev.WARN })
			if e > 0 then
				return "- build failed -"
			end

			if w > 0 then
				return "- linter failed -"
			end
			return ""
		end

		local function diagnostic_summary()
			local sev = vim.diagnostic.severity
			local e = #vim.diagnostic.get(0, { severity = sev.ERROR })
			local w = #vim.diagnostic.get(0, { severity = sev.WARN })
			-- local i = #vim.diagnostic.get(0, { severity = sev.INFO })
			-- local h = #vim.diagnostic.get(0, { severity = sev.HINT })

			local parts = {}

			if e > 0 then
				table.insert(parts, string.format("󰢱 %d", e))
			end
			if w > 0 then
				table.insert(parts, string.format(" %d", w))
			end
			-- if i > 0 then
			-- 	table.insert(parts, string.format(" %d", i))
			-- end
			-- if h > 0 then
			-- 	table.insert(parts, string.format(" %d", h))
			-- end

			if #parts == 0 then
				return ""
			end

			return "" .. table.concat(parts, " ") .. ""
		end

		local function current_file_name()
			local bufname = vim.fn.expand("%:t") -- filename with extension
			if bufname == "" then
				return "No File"
			end
			local w = vim.fn.winwidth(0)
			local parent = vim.fn.fnamemodify(vim.fn.expand("%:h"), ":t")
			local file = vim.fn.expand("%:t")
			local name = (w > 80) and (parent .. "/" .. file) or file
			local mod = vim.bo.modified and "+" or ""
			return name .. mod
		end

		-- Clear background colors
		local theme = vim.deepcopy(require("lualine.themes.onelight"))

		for _mode, grp in pairs(theme) do
			if type(grp) == "table" then
				grp.c = grp.c or {}
				grp.c.bg = "OldLace"
				grp.c.fg = "Black"
			end
		end

		opts.options.theme = theme

		opts.disabled_filetypes = { "aerial", "Trouble", "NvimTree" }

		opts.options.component_separators = { left = "│", right = "│" }
		opts.options.section_separators = { left = "█", right = "█" }

		local breadcrumbs = require("lspsaga.symbol.winbar").get_bar

		if breadcrumbs == nil or breadcrumbs == "" then
			breadcrumbs = current_file_name()
		end

		-- active --
		opts.sections = {
			lualine_a = {
				{ "mode", fmt = vim_mode, color = { fg = "#ffffff", bg = "#000000", gui = "bold" } },
			},
			lualine_b = {},
			lualine_c = {
				{
					current_file_name,
					colors = { fg = "Black", bg = "OldLace", gui = "bold" },
				},
				-- {
				--   breadcrumbs,
				-- },
			},
			lualine_x = {},
			lualine_y = {
				{
					diagnostic_summary,
					color = { fg = "Black", bg = "OldLace", gui = "bold" },
					cond = function()
						return vim.fn.winwidth(0) > 60
					end,
				},
			},
			lualine_z = {
				-- { branch_name, color = { fg = "White", bg = "Black" } },
				{ total_lines, color = { fg = "white", bg = "Black", gui = "bold" } },
			},
		}

		opts.inactive_sections = {
			lualine_a = {},
			lualine_b = {},
			lualine_c = {
				{
					current_file_name,
					colors = { fg = "Black", bg = "OldLace", gui = "bold" },
				},
			}, --{{ breadcrumbs }},
			lualine_x = {},
			lualine_y = {},
		}

		return opts
	end,
}
