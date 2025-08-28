return {
	"nvim-lualine/lualine.nvim",
	opts = function(_, opts)
		opts = opts or {}
		opts.options = opts.options or {}
		opts.sections = opts.sections or {}

		local function mode()
			local m = vim.fn.mode()
			return (m == "n" and "N")
				or (m == "i" and "I")
				or (m == "v" and "V")
				or (m == "R" and "R")
				or (m == "c" and "C")
				or ""
		end

		local function branch_text()
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

		local function cursor_progress()
			local line = vim.api.nvim_win_get_cursor(0)[1]
			local total = vim.api.nvim_buf_line_count(0)
			return string.format("%d:%d", line, total)
		end

		local function file_status()
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

		local function diag_summary()
			local sev = vim.diagnostic.severity
			local e = #vim.diagnostic.get(0, { severity = sev.ERROR })
			local w = #vim.diagnostic.get(0, { severity = sev.WARN })
			local i = #vim.diagnostic.get(0, { severity = sev.INFO })
			local h = #vim.diagnostic.get(0, { severity = sev.HINT })

			local parts = {}

			if e > 0 then
				table.insert(parts, string.format("󰢱 %d", e))
			end
			if w > 0 then
				table.insert(parts, string.format(" %d", w))
			end
			if i > 0 then
				table.insert(parts, string.format(" %d", i))
			end
			if h > 0 then
				table.insert(parts, string.format(" %d", h))
			end

			if #parts == 0 then
				return ""
			end

			return "" .. table.concat(parts, " ") .. ""
		end

		local function diag_color()
			local sev = vim.diagnostic.severity
			if #vim.diagnostic.get(0, { severity = sev.ERROR }) > 0 then
				return { fg = "#ffffff", bg = "#cc0000", gui = "bold" }
			elseif #vim.diagnostic.get(0, { severity = sev.WARN }) > 0 then
				return { fg = "#000000", bg = "#ffd24d", gui = "bold" }
			end
			return { fg = "#000000", bg = "White" } -- ok/clean
		end

		local function file_name()
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
				grp.c.bg = "White"
				grp.c.fg = "Black"
			end
		end

		opts.options.theme = theme

    opts.disabled_filetypes = { "aerial", "Trouble", "NvimTree" }

		opts.options.component_separators = { left = "│", right = "│" }
		opts.options.section_separators = { left = "█", right = "█" }

    -- active --
		opts.sections = {
			lualine_a = {
				{ "mode", fmt = mode, color = { fg = "#ffffff", bg = "#000000", gui = "bold" } },
			},
			lualine_b = {},
			lualine_c = {
				{ file_name, color = { fg = "Black", bg = "white", gui = "bold" } },
			},
			lualine_x = {
				{ file_status, color = { fg = "black", bg = "white", gui = "bold" } },
			},
			lualine_y = {
				{
					diag_summary,
          color = { fg = "Black", bg = "White", gui = "bold" },
					cond = function()
						return vim.fn.winwidth(0) > 60
					end,
				},
			},
			lualine_z = {
				{ branch_text, color = { fg = "White", bg = "Black" } },
        { cursor_progress },
      } ,
		}


    -- inactive --
		opts.inactive_sections = {
			lualine_a = {},
			lualine_b = {},
			lualine_c = {
				{
          function()
            return "   " .. file_name()
          end,
          color = { fg = "Black", bg = "white", gui = "bold" } 
        },
			},
			lualine_x = {},
			lualine_y = {},
			lualine_z = {},
		}

		return opts
	end,
}
