local wezterm = require 'wezterm'
local config = wezterm.config_builder()
local mux = wezterm.mux

wezterm.on('gui-startup', function(cmd)
  local tab, pane, window = mux.spawn_window(cmd or {})
  window:gui_window():maximize()
end)

if wezterm.target_triple:find("windows") then
  config.default_prog = {
    "wsl.exe",
    "--distribution", "Ubuntu",
    "--exec",
    "zsh"
  }
end

-- GUI

config.font = wezterm.font("JetBrains Mono", { weight = "Regular" })
config.font_rules = {
  {
    intensity = "Bold",
    font = wezterm.font("JetBrains Mono", { weight = "ExtraBold" }),
  },
  {
    intensity = "Half",
    font = wezterm.font("JetBrains Mono", { weight = "DemiBold" }),
  },
}

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

if wezterm.target_triple:find("windows") then
  config.colors = {
    background = "#ffffff",
    foreground = "#000000",
  } 
else
   config.colors = {
    background = "#e1e3ec",
    foreground = "#000000",
  } 
end

config.color_scheme = nil        

config.colors = {
  -- core
  foreground = '#000000',  -- text: jet-black
  background = '#ffffff',  -- page: paper-white

  -- cursor
  cursor_bg     = '#000000',
  cursor_fg     = '#ffffff',
  cursor_border = '#000000',

  -- selection highlight
  selection_bg = '#bfbfbf', -- silver
  selection_fg = '#000000',

  -- 16-color ANSI slots remapped to greys
  ansi = {
    '#000000', -- 0  black
    '#6e6e6e', -- 1  “red”   → dark grey
    '#6e6e6e', -- 2  “green” → dark grey
    '#6e6e6e', -- 3  “yellow”
    '#6e6e6e', -- 4  “blue”
    '#6e6e6e', -- 5  “magenta”
    '#6e6e6e', -- 6  “cyan”
    '#bfbfbf', -- 7  “white” → light grey
  },
  brights = {
    '#404040', -- 8  bright-black
    '#9f9f9f', -- 9  bright-red
    '#9f9f9f', -- 10 bright-green
    '#9f9f9f', -- 11 bright-yellow
    '#9f9f9f', -- 12 bright-blue
    '#9f9f9f', -- 13 bright-magenta
    '#9f9f9f', -- 14 bright-cyan
    '#ffffff', -- 15 bright-white
  },
}

-- keep bold text from turning “bright” and picking lighter greys
config.bold_brightens_ansi_colors = false

-- config.bold_brightens_ansi_colors = true

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