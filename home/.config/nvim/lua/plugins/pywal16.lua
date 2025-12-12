local function reload_lualine()
	local lualine = require("lualine")

	-- Hide statusline
	lualine.hide({ unhide = false })

	-- Stop any timers (internal refresh timer)
	if lualine.timer and lualine.timer:is_active() then
		lualine.timer:stop()
	end

	-- Clear augroups
	pcall(vim.api.nvim_del_augroup_by_name, "lualine")
	pcall(vim.api.nvim_del_augroup_by_name, "lualine_stl_refresh")

	-- Purge all cached modules
	for name, _ in pairs(package.loaded) do
		if name:match("^lualine") then
			package.loaded[name] = nil
		end
	end

	-- Force garbage collection
	collectgarbage("collect")

	-- Reload
	require("lazy").reload({ plugins = { "lualine.nvim" } })
end

local function updateBackground(themeEngine)
	local colors = require("pywal16.core").get_colors()

	vim.api.nvim_set_hl(0, "Normal", { fg = colors.foreground, bg = colors.background })
end

local function reloadPlugins()
	local plugins = require("lazy").plugins()
	local plugin_names = {
		"pywal16.nvim",
		"indent-blankline.nvim",
		"twilight.nvim",
		"limelight.vim",
	}
	local colors = require("pywal16.core").get_colors()

	-- Remove background highlights for indent-blankline
	vim.api.nvim_set_hl(0, "IblIndent", { fg = colors.color8, bg = "NONE" })
	vim.api.nvim_set_hl(0, "IblWhitespace", { bg = "NONE" })
	vim.api.nvim_set_hl(0, "@ibl.indent.char.1", { fg = colors.color8, bg = "NONE" })
	vim.api.nvim_set_hl(0, "@ibl.whitespace.char.1", { bg = "NONE" })

	reload_lualine()

	require("lazy").reload({ plugins = plugin_names })
end

local function subscribeToGlobalThemeChange(themeEngine)
	local uv = vim.loop

	local wal_file = vim.fn.expand("~/.cache/wal/colors.json")

	local h = uv.new_fs_event()

	h:start(wal_file, {}, function()
		if debounce_timer then
			debounce_timer:stop()
			debounce_timer:close()
		end

		debounce_timer = uv.new_timer()

		debounce_timer:start(300, 0, function()
			vim.schedule(function()
				local current_mtime = uv.fs_stat(wal_file).mtime.sec
				if current_mtime ~= last_mtime then
					last_mtime = current_mtime

					updateBackground(themeEngine)

					-- reloadPlugins()
				end
			end)
		end)
	end)
end

return {
	"uZer/pywal16.nvim",
	lazy = false,
	config = function()
		vim.defer_fn(function()
			vim.cmd([[colorscheme pywal16]])
		end, 10)

		local themeEngine = require("pywal16.core")
		updateBackground(themeEngine)
		subscribeToGlobalThemeChange(themeEngine)
	end,
}
