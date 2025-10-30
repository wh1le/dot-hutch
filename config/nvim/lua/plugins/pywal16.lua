local function updateBackground(themeEngine)
	local colors = require("pywal16.core").get_colors()

	if colors.background == "#ffffff" then
		vim.api.nvim_set_hl(0, "Normal", { fg = colors.foreground, bg = colors.background })
	end
end

local function subscribeToGlobalThemeChange(themeEngine)
	local uv = vim.loop
	local wal_file = vim.fn.expand("~/.cache/wal/colors-wal.vim")
	local h = uv.new_fs_event()

	h:start(wal_file, {}, function()
		vim.schedule(function()
			vim.cmd([[colorscheme pywal16]])
			updateBackground(themeEngine)
		end)
	end)
end

return {
	"uZer/pywal16.nvim",
	config = function()
		local themeEngine = require("pywal16.core")

		updateBackground(themeEngine)
		subscribeToGlobalThemeChange(themeEngine)
	end,
}
