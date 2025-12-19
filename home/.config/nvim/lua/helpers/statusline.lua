NM.statusline = {
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

	colors = function()
		return {}
	end,

	current_mode = function()
		local m = vim.fn.mode()

		local total = vim.api.nvim_buf_line_count(0)
		local pad = string.rep(" ", math.max(#tostring(total), 0))

		local res = (m == "n" and "N")
			or (m == "i" and "I")
			or (m == "V" and "V")
			or (m == "R" and "R")
			or (m == "c" and "C")
			or ""
		-- return pad .. "[" .. res .. "]"
		return "" .. res .. ""
	end,

	branch_name = function()
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
	end,

	total_lines = function()
		local line = vim.api.nvim_win_get_cursor(0)[1]
		local total = vim.api.nvim_buf_line_count(0)
		return string.format("%d:%d", line, total)
	end,

	linter_status = function()
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
	end,

	diagnostic_summary = function()
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

		-- NOTE: ignore for now
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
	end,

	-- NOTE: original
	-- current_file_name = function()
	-- 	local bufname = vim.fn.expand("%:t") -- filename with extension
	-- 	if bufname == "" then
	-- 		return "[No File]"
	-- 	end
	--
	-- 	local fileDepth = vim.fn.split(vim.fn.fnamemodify(vim.fn.expand("%:p"), ":."), "/")
	-- 	print(fileDepth - 1)
	-- 	os.execute('notify-send "Neovim" "' .. fileDepth - 1 .. '"')
	--
	-- 	-- local w = vim.fn.winwidth(0)
	-- 	local parent = vim.fn.fnamemodify(vim.fn.expand("%:h"), ":t")
	--
	-- 	local file = vim.fn.expand("%:t")
	--
	-- 	local name = parent .. "/" .. file
	--
	-- 	local mod = vim.bo.modified and "+" or ""
	--
	-- 	return name .. mod
	-- end,

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

	-- lsp_saga_breadcrumbs = function()
	-- 	local breadcrumbs = require("lspsaga.symbol.winbar").get_bar
	--
	-- 	if breadcrumbs == nil or breadcrumbs == "" then
	-- 		return NM.statusline.current_file_name()
	-- 	else
	-- 		return breadcrumbs
	-- 	end
	-- end,

	-- lsp_state_icon = function()
	-- 	-- local clients = vim.lsp.get_clients({ bufnr = 0 })
	-- 	-- if #clients == 0 then
	-- 	-- 	return "not ok"
	-- 	-- end
	-- 	--
	-- 	-- for _, client in ipairs(clients) do
	-- 	-- 	if client.attached_buffers[vim.api.nvim_get_current_buf()] then
	-- 	-- 		return "ok"
	-- 	-- 	end
	-- 	-- end
	-- 	--
	-- 	-- return "not ok"
	--
	-- 	local clients = vim.lsp.get_clients({ bufnr = 0 })
	-- 	local buf = vim.api.nvim_get_current_buf()
	-- 	if #clients == 0 then
	-- 		return "not ok"
	-- 	end
	--
	-- 	for _, client in ipairs(clients) do
	-- 		if not client.attached_buffers[buf] then
	-- 			return "not ok"
	-- 		end
	-- 	end
	--
	-- 	return "ok"
	-- end,

	lsp = {
		-- _get_available_servers_for = function(filetype)
		-- 	local ok, cfgs = pcall(require, "lspconfig.configs")
		-- 	if not ok then
		-- 		return {}
		-- 	end
		--
		-- 	local list = {}
		-- 	for name, c in pairs(cfgs) do
		-- 		local dc = c.document_config and c.document_config.default_config
		-- 		if dc and dc.filetypes and vim.tbl_contains(dc.filetypes, filetype) then
		-- 			table.insert(list, name)
		-- 		end
		-- 	end
		-- 	return list
		-- end,

		_get_attached_servers = function(buffer)
			local attached = {}

			local ignore = {
				typos_lsp = true,
			}

			local buf = vim.api.nvim_get_current_buf()

			for _, client in ipairs(vim.lsp.get_clients()) do
				if client.attached_buffers[buf] then
					if not ignore[client.name] then
						table.insert(attached, client.name)
					end
				end
			end

			return attached
		end,

		get_icon = function(available, attached)
			if #attached == 0 then
				return ""
			else
				return ""
			end

			-- return " lsp " .. "(" .. attached .. "/" .. available .. ")" .. ": " .. table.concat(attached, ", ")
			return string.format(" lsp: %s (%d/%d)", table.concat(attached, ", "), #attached, #available)
		end,
	},

	lsp_state_icon = function()
		if not vim.bo.filetype or vim.bo.filetype == "" then
			return ""
		end

		local available_servers = NM.statusline.lsp._get_available_servers_for(vim.bo.filetype)
		local attached_servers = NM.statusline.lsp._get_attached_servers()

		return NM.statusline.lsp.get_icon(available_servers, attached_servers)
	end,

	colors = {
		backgroundColor = "Black",
		foregroundColor = "gray",
	},
}
