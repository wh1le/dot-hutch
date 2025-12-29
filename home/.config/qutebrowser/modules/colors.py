import json
# import subprocess
from pathlib import Path

DEFAULT_USER_SCRIPTS = []
DEFAULT_USER_STYLESHEETS = []
USER_THEME_PATH = Path.home() / ".config/qutebrowser/styles/os_theme.css"

class PyWallColors:
    PYWAL_COLORS_PATH = Path.home() / ".cache/wal/colors.json" 

    def __init__(self):
        self._pywal_colors = None

    def read(self):
        if self._pywal_colors is None:
            with open(self.PYWAL_COLORS_PATH) as f:
                self._pywal_colors = json.load(f)

        return self._pywal_colors


class EinkJSToggle:
    GREASE_DIR = Path("~/.config/qutebrowser/greasemonkey").expanduser()
    ENABLED_PATH = GREASE_DIR / "darkreader.js"
    DISABLED_PATH = GREASE_DIR / "darkreader.js.disabled"

    def enable_eink_js(self):
        if self.ENABLED_PATH.exists():
            return 
        else:
            self.DISABLED_PATH.rename(self.ENABLED_PATH)

    def disable_eink_js(self):
        if self.DISABLED_PATH.exists():
            return
        else:
            self.ENABLED_PATH.rename(self.DISABLED_PATH)

def browser_colors(c, config):
    wal = PyWallColors().read()

    c.colors.statusbar.url.fg = wal["colors"]["color13"]
    c.colors.statusbar.url.success.https.fg = wal["colors"]["color13"]
    c.colors.statusbar.url.hover.fg = wal["colors"]["color12"]

    c.colors.statusbar.normal.bg = wal["colors"]["color0"]
    c.colors.statusbar.normal.fg = wal["colors"]["color7"]

    c.colors.statusbar.command.bg = wal["colors"]["color0"]
    c.colors.statusbar.command.fg = wal["colors"]["color4"]  

    c.colors.statusbar.insert.bg = wal["colors"]["color2"]  
    c.colors.statusbar.insert.fg = "white"

    c.colors.statusbar.passthrough.bg = wal["colors"]["color5"]  
    c.colors.statusbar.passthrough.fg = wal["colors"]["color0"]

    c.colors.statusbar.private.bg = wal["colors"]["color1"]  
    c.colors.statusbar.private.fg = wal["colors"]["color0"]

    c.colors.statusbar.caret.bg = wal["colors"]["color6"]   
    c.colors.statusbar.caret.fg = wal["colors"]["color0"]
    c.colors.statusbar.caret.selection.bg = wal["colors"]["color3"]  
    c.colors.statusbar.caret.selection.fg = wal["colors"]["color0"]

    # Tabs - transparent background, subtle unselected, accent on selected
    c.colors.tabs.bar.bg = "#00000000"
    c.colors.tabs.even.bg = "#00000000"
    c.colors.tabs.odd.bg = "#00000000"

    c.colors.tabs.even.fg = wal["colors"]["color7"]  # light gray instead of color8
    c.colors.tabs.odd.fg = wal["colors"]["color7"]

    c.colors.tabs.selected.even.bg = wal["colors"]["color4"]  # accent (blue)
    c.colors.tabs.selected.odd.bg = wal["colors"]["color4"]
    c.colors.tabs.selected.even.fg = wal["colors"]["color0"]  # dark text
    c.colors.tabs.selected.odd.fg = wal["colors"]["color0"]

    # Indicator (loading/audio)
    c.colors.tabs.indicator.start = wal["colors"]["color5"]
    c.colors.tabs.indicator.stop = wal["colors"]["color2"]
    c.colors.tabs.indicator.error = wal["colors"]["color1"]

    # Pinned tabs
    c.colors.tabs.pinned.even.bg = "#00000000"
    c.colors.tabs.pinned.odd.bg = "#00000000"

    c.colors.tabs.pinned.even.bg = wal["colors"]["color0"]
    c.colors.tabs.pinned.even.fg = wal["colors"]["color6"]
    c.colors.tabs.pinned.odd.bg = wal["colors"]["color0"]
    c.colors.tabs.pinned.odd.fg = wal["colors"]["color6"]

    c.colors.tabs.pinned.selected.even.bg = wal["colors"]["color4"]
    c.colors.tabs.pinned.selected.odd.bg = wal["colors"]["color4"]
    c.colors.tabs.pinned.selected.even.fg = wal["colors"]["color0"]
    c.colors.tabs.pinned.selected.odd.fg = wal["colors"]["color0"]

    c.colors.hints.bg = wal["special"]["background"]
    c.colors.hints.fg = wal["special"]["foreground"]
    c.hints.border = wal["special"]["foreground"]

    c.colors.completion.item.selected.match.fg = wal["colors"]["color6"]
    c.colors.completion.match.fg = wal["colors"]["color6"]

    c.colors.tabs.indicator.start = wal["colors"]["color10"]
    c.colors.tabs.indicator.stop = wal["colors"]["color8"]
    c.colors.completion.odd.bg = wal["special"]["background"]
    c.colors.completion.even.bg = wal["special"]["background"]
    c.colors.completion.fg = wal["special"]["foreground"]
    c.colors.completion.category.bg = wal["special"]["background"]
    c.colors.completion.category.fg = wal["special"]["foreground"]
    c.colors.completion.item.selected.bg = wal["special"]["background"]
    c.colors.completion.item.selected.fg = wal["special"]["foreground"]

    c.colors.messages.info.bg = wal["special"]["background"]
    c.colors.messages.info.fg = wal["special"]["foreground"]
    c.colors.messages.error.bg = wal["special"]["background"]
    c.colors.messages.error.fg = wal["special"]["foreground"]
    c.colors.downloads.error.bg = wal["special"]["background"]
    c.colors.downloads.error.fg = wal["special"]["foreground"]

    c.colors.downloads.bar.bg = wal["special"]["background"]
    c.colors.downloads.start.bg = wal["colors"]["color10"]
    c.colors.downloads.start.fg = wal["special"]["foreground"]
    c.colors.downloads.stop.bg = wal["colors"]["color8"]
    c.colors.downloads.stop.fg = wal["special"]["foreground"]

    c.colors.tooltip.bg = wal["special"]["background"]
    c.colors.webpage.bg = wal["special"]["background"]

    # dark mode setup
    c.colors.webpage.darkmode.enabled = True
    c.colors.webpage.darkmode.algorithm = 'lightness-cielab'
    c.colors.webpage.darkmode.policy.images = 'never'

    # Temporary overrides to try
    c.colors.statusbar.url.fg = "#8be9fd"
    c.colors.statusbar.url.success.https.fg = "#8be9fd"
    c.colors.statusbar.url.hover.fg = "#bd93f9"
    c.colors.statusbar.normal.bg = "#282a36"
    c.colors.statusbar.normal.fg = "#f8f8f2"
    c.colors.statusbar.command.bg = "#282a36"
    c.colors.statusbar.command.fg = "#f8f8f2"

    c.colors.statusbar.insert.bg = "#7a8a4a"
    c.colors.statusbar.insert.fg = "#f8f8f2"

    c.colors.statusbar.passthrough.bg = "#6272a4"  # medium gray
    c.colors.statusbar.passthrough.fg = "#f8f8f2"
    c.colors.statusbar.private.bg = "#ff5555"  # red (keep distinct)
    c.colors.statusbar.private.fg = "#282a36"
    c.colors.statusbar.caret.bg = "#6272a4"
    c.colors.statusbar.caret.fg = "#f8f8f2"
    c.colors.statusbar.caret.selection.bg = "#44475a"
    c.colors.statusbar.caret.selection.fg = "#f8f8f2"

    c.colors.statusbar.url.fg = "#6272a4"  # darker blue-gray
    c.colors.statusbar.url.success.https.fg = "#6272a4"
    c.colors.statusbar.url.hover.fg = "#8be9fd"  # brighter on hover

def set_os_theme_css(c, config):
    wal = PyWallColors().read()

    user_css = Path(USER_THEME_PATH).expanduser()

    user_css.write_text(f"""
        html, body, body > *, #page, #content, main, .container {{
          background-color: {wal["special"]["background"]} !important;
          background-image: none !important;
        }}
    """)

def settings(c, config):
    config.set('colors.webpage.darkmode.enabled', False, 'file://*')
    c.colors.webpage.darkmode.contrast = 0
    c.colors.webpage.preferred_color_scheme = "dark"
    c.colors.webpage.darkmode.enabled = True
    c.colors.webpage.darkmode.policy.images = "never"
    c.colors.webpage.darkmode.policy.page = "smart"

def apply_colors(c, config):
    browser_colors(c, config)
    settings(c, config)
    set_os_theme_css(c, config)

    c.content.user_stylesheets = [
        *DEFAULT_USER_STYLESHEETS,
        str(USER_THEME_PATH)
    ]

    EinkJSToggle().disable_eink_js()

    return c

# We need this to make sure script doesn't fail on startup and works with live reload
# For example: qutebrowser ':config-source ~/.config/qutebrowser/modules/colors.py'
try: 
    apply_colors(c, config)
except NameError:
    pass
