local wezterm = require("wezterm")
local config = wezterm.config_builder()

if wezterm.target_triple:find("windows") then
	config.default_prog = { "wsl.exe", "--distribution", "Ubuntu", "--exec", "zsh", }
end

config.font = wezterm.font_with_fallback({ family = "JetBrainsMonoNL Nerd Font", weight = "Regular"})

-- remove
-- config.font_rules = {
-- 	{
-- 		intensity = "Bold",
--     font = wezterm.font_with_fallback({
--       { family = "JetBrainsMonoNL Nerd Font", weight = "ExtraBold" },
--     }),
-- 	},
-- 	{
-- 		intensity = "Half",
--     font = wezterm.font_with_fallback({
--       { family = "JetBrainsMonoNL Nerd Font", weight = "DemiBold" },
--     }),
-- 	},
-- 	{
-- 		italic = true,
--     font = wezterm.font_with_fallback({
--       { family = "JetBrainsMonoNL Nerd Font", weight = "ExtraLight", italic = true },
--     }),
-- 	},
-- }
if wezterm.target_triple:find("windows") then
	config.font_size = 9.5
else
	config.font_size = 15.5
end

config.window_padding = { left = 6, right = 2, top = 2, bottom = 2 }
config.enable_tab_bar = false

config.color_schemes = {
  wal = wezterm.color.load_scheme(
    wezterm.home_dir .. '/.cache/wal/colors-wezterm.toml'
  )
}

config.color_scheme = "wal"

config.audible_bell = "Disabled"
config.visual_bell = { fade_in_duration_ms = 0, fade_out_duration_ms = 0 }
config.notification_handling = "NeverShow"
config.check_for_updates = false

-- HOTKEYS
config.keys = {
	-- Disable metakeys
	{
		key = "j",
		mods = "ALT",
		action = wezterm.action.SendKey({
			key = "j",
			mods = "ALT",
		}),
	},
	{
		key = "v",
		mods = "CTRL",
		action = wezterm.action.PasteFrom("Clipboard"),
	},
	-- Disable Ctrl+Shift+V
	{
		key = "V",
		mods = "CTRL|SHIFT",
		action = wezterm.action.DisableDefaultAssignment,
	},
}

return config