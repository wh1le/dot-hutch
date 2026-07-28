vim.opt.termguicolors = true

vim.g.terminal_color_0 = "#000000"
vim.g.terminal_color_1 = "#cc0000"
vim.g.terminal_color_2 = "#4e9a06"
vim.g.terminal_color_3 = "#c4a000"
vim.g.terminal_color_4 = "#3465a4"
vim.g.terminal_color_5 = "#75507b"
vim.g.terminal_color_6 = "#06989a"
vim.g.terminal_color_7 = "#d3d7cf"
vim.g.terminal_color_8 = "#555753"
vim.g.terminal_color_9 = "#ef2929"
vim.g.terminal_color_10 = "#8ae234"
vim.g.terminal_color_11 = "#fce94f"
vim.g.terminal_color_12 = "#729fcf"
vim.g.terminal_color_13 = "#ad7fa8"
vim.g.terminal_color_14 = "#34e2e2"
vim.g.terminal_color_15 = "#eeeeec"

local function pywal_colors()
	local f = io.open(vim.fn.expand("~/.cache/wal/colors.json"), "r")
	if not f then
		return {}
	end
	local ok, data = pcall(vim.json.decode, f:read("*a"))
	f:close()
	if not ok then
		return {}
	end
	return vim.tbl_extend("keep", data.colors or {}, {
		bg = data.special and data.special.background,
		fg = data.special and data.special.foreground,
		cursor = data.special and data.special.cursor,
	})
end

-- dim every hex color in a spec table toward black, keeping hue and saturation
local function dim_colors(value, dim_factor)
	dim_factor = dim_factor or 0.20
	local Color = require("github-theme.lib.color")
	if type(value) == "table" then
		local out = {}
		for key, inner in pairs(value) do
			out[key] = dim_colors(inner, dim_factor)
		end
		return out
	elseif type(value) == "string" and value:sub(1, 1) == "#" then
		return Color.from_hex(value):shade(-dim_factor):to_css()
	end
	return value
end

-- mute every hex color by scaling saturation and value, keeping hue intact
local function desaturate_colors(value, saturation_scale, value_scale)
	saturation_scale = saturation_scale or 0.8
	value_scale = value_scale or 0.9
	local Color = require("github-theme.lib.color")
	if type(value) == "table" then
		local out = {}
		for key, inner in pairs(value) do
			out[key] = desaturate_colors(inner, saturation_scale, value_scale)
		end
		return out
	elseif type(value) == "string" and value:sub(1, 1) == "#" then
		local hsv = Color.from_hex(value):to_hsv()
		return Color.from_hsv(hsv.hue, hsv.saturation * saturation_scale, hsv.value * value_scale):to_css()
	end
	return value
end

-- mirror the active theme into a highlight namespace with muted colors, then park
local function setup_inactive_desaturation(ignore_filetype_list)
	local namespace = vim.api.nvim_create_namespace("inactive_desaturated")
	local inactive_saturation_scale = 0.65
	local inactive_value_scale = 0.75

	local function refresh()
		for name, attrs in pairs(vim.api.nvim_get_hl(0, {})) do
			local hl = vim.deepcopy(attrs)
			for _, key in ipairs({ "fg", "bg", "sp" }) do
				if type(attrs[key]) == "number" then
					hl[key] = desaturate_colors(
						string.format("#%06x", attrs[key]),
						inactive_saturation_scale,
						inactive_value_scale
					)
				end
			end
			vim.api.nvim_set_hl(namespace, name, hl)
		end
	end

	-- pickers, trees and prompts stay full color and never dim the window they open over
	local ignore_filetypes = {
		["neo-tree"] = true,
		["NvimTree"] = true,
		["oil"] = true,
		["fzf"] = true,
		["snacks_picker_list"] = true,
		["snacks_picker_input"] = true,
		["TelescopePrompt"] = true,
		["TelescopeResults"] = true,
	}

	local function is_ignored(buf)
		return ignore_filetypes[vim.bo[buf].filetype] or vim.bo[buf].buftype == "prompt"
	end

	refresh()
	vim.api.nvim_create_autocmd("ColorScheme", { callback = refresh })
	vim.api.nvim_create_autocmd({ "WinEnter", "BufWinEnter" }, {
		callback = function()
			vim.api.nvim_win_set_hl_ns(0, 0)
		end,
	})
	vim.api.nvim_create_autocmd("WinLeave", {
		callback = function(args)
			if is_ignored(args.buf) then
				return
			end
			local leaving = vim.api.nvim_get_current_win()
			vim.schedule(function()
				if vim.api.nvim_win_is_valid(leaving) and not is_ignored(vim.api.nvim_win_get_buf(0)) then
					vim.api.nvim_win_set_hl_ns(leaving, namespace)
				end
			end)
		end,
	})

	-- when nvim itself loses focus (moved to another tmux pane), dim every window
	vim.api.nvim_create_autocmd("FocusLost", {
		callback = function()
			for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
				if vim.api.nvim_win_is_valid(win) and not is_ignored(vim.api.nvim_win_get_buf(win)) then
					vim.api.nvim_win_set_hl_ns(win, namespace)
				end
			end
		end,
	})
	vim.api.nvim_create_autocmd("FocusGained", {
		callback = function()
			vim.api.nvim_win_set_hl_ns(0, 0)
		end,
	})
end

-- disable LSP semantic tokens so github-theme's treesitter colors aren't overridden
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if client then
			client.server_capabilities.semanticTokensProvider = nil
		end
	end,
})

return {
	{
		"uZer/pywal16.nvim",
	},
	{
		"projekt0n/github-nvim-theme",
		name = "github-theme",
		lazy = false,
		priority = 1000,
		config = function()
			local pywal = pywal_colors()
			local bg = pywal.bg
			local Color = require("github-theme.lib.color")
			local bg_inactive = Color.from_hex(bg):shade(-0.1):to_css()

			local base = require("github-theme.spec").load("github_dark_dimmed")

			require("github-theme").setup({
				compile = true,
				options = {
					terminal_colors = false,
					dim_inactive = true,
					styles = {
						comments = "italic",
						keywords = "NONE",
						functions = "NONE",
						variables = "NONE",
						strings = "NONE",
					},
				},
				specs = {
					github_dark_dimmed = {
						bg0 = bg_inactive,
						bg1 = bg,
						syntax = desaturate_colors(dim_colors(base.syntax)),
						diag = desaturate_colors(dim_colors(base.diag)),
						git = desaturate_colors(dim_colors(base.git)),
						diff = desaturate_colors(dim_colors(base.diff)),
					},
				},
				groups = {
					all = {
						["@punctuation.bracket.curly"] = { fg = "fg1", style = "bold" },
						["@punctuation.delimiter"] = { fg = "fg3" },
						["@operator"] = { fg = "fg3" },
					},
				},
			})

			vim.cmd.colorscheme("github_dark_dimmed")
			setup_inactive_desaturation()
		end,
	},
	{
		"brenoprata10/nvim-highlight-colors",
		config = function()
			require("nvim-highlight-colors").setup({})
		end,
	},
}
