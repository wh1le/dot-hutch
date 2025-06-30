local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- GUI
-- config.font
config.font_size = 12.5
config.enable_tab_bar = true
config.use_fancy_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.hide_mouse_cursor_when_typing = true
config.window_background_opacity = 1.0
config.window_decorations = "RESIZE" -- no titlebar
config.window_padding = { left = 2, right = 2, top = 2, bottom = 2, }

-- COLORS
config.color_scheme = 'AdventureTime'
config.colors = {
  background = "#e1e3ec",
  foreground = "#000000",
}

-- HOTKEYS
config.keys = {
  -- Disable metakeys
  {
    key = "j",
    mods = "ALT",
    action = wezterm.action.SendKey {
      key = "j",
      mods = "ALT",
    },
  }
}

config.enable_csi_u_key_encoding = true

return config