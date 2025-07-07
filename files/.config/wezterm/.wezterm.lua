local wezterm = require 'wezterm'
local config = wezterm.config_builder()
local mux = wezterm.mux

wezterm.on('gui-startup', function(cmd)
  local tab, pane, window = mux.spawn_window(cmd or {})
  window:gui_window():maximize()
end)

config.default_prog = {
  "wsl.exe",
  "--distribution", "Ubuntu",
  "--exec",
  "zsh"
}

-- GUI

config.font = wezterm.font("JetBrains Mono")
config.freetype_render_target = "HorizontalLcd"
config.freetype_load_target = "Light"

if wezterm.target_triple:find("windows") then
  config.font_size = 9.5
else
   config.font_size = 12.5
end

config.enable_tab_bar = true
config.use_fancy_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.hide_mouse_cursor_when_typing = true
config.window_background_opacity = 1.0
config.window_decorations = "TITLE | RESIZE"
config.window_padding = { left = 2, right = 2, top = 2, bottom = 2, }
config.text_background_opacity = 1.0


-- COLORS
config.color_scheme = 'Builtin Simple'
-- if wezterm.target_triple:find("windows") then
--   config.colors = {
--     background = "#ffffff",
--     foreground = "#000000",
--   } 
-- else
--    config.colors = {
--     background = "#e1e3ec",
--     foreground = "#000000",
--   } 
-- end

config.colors = {
  background = "#ffffff",
  foreground = "#000000",
}

config.bold_brightens_ansi_colors = true

config.audible_bell = "Disabled"
config.visual_bell = {fade_in_duration_ms = 0, fade_out_duration_ms = 0}  -- zero-length = off :contentReference[oaicite:1]{index=1}
config.notification_handling = "NeverShow"
config.check_for_updates = false

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