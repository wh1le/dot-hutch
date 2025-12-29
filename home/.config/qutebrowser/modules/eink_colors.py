import json
import subprocess
from pathlib import Path

DEFAULT_USER_SCRIPTS = []
DEFAULT_USER_STYLESHEETS = []
EINK_WEB_COLORS_PATH = "~/.config/qutebrowser/styles/eink_web_colors.css"

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

# EINK_WEB_COLORS_PATH = Path.home() / ".config/qutebrowser/styles/eink_web_colors.css"

def broser_colors(c, config):
    black = "#000000"
    white = "#ffffff"
    light_gray = "#f0f0f0"
    mid_gray = "#F2F2F2"
    dark_gray = "#9B9B9B"

    c.colors.statusbar.url.fg = black
    c.colors.statusbar.url.success.https.fg = dark_gray
    c.colors.statusbar.url.hover.fg = black

    c.colors.statusbar.normal.bg = white
    c.colors.statusbar.normal.fg = black

    c.colors.statusbar.command.bg = white
    c.colors.statusbar.command.fg = black

    c.colors.statusbar.insert.bg = light_gray
    c.colors.statusbar.insert.fg = black

    c.colors.statusbar.passthrough.bg = mid_gray
    c.colors.statusbar.passthrough.fg = black

    c.colors.statusbar.private.bg = dark_gray
    c.colors.statusbar.private.fg = white

    c.colors.statusbar.caret.bg = mid_gray
    c.colors.statusbar.caret.fg = black
    c.colors.statusbar.caret.selection.bg = dark_gray
    c.colors.statusbar.caret.selection.fg = white

    # Tabs
    c.colors.tabs.bar.bg = white
    c.colors.tabs.even.bg = white
    c.colors.tabs.odd.bg = white

    c.colors.tabs.even.fg = black
    c.colors.tabs.odd.fg = black

    c.colors.tabs.selected.even.bg = dark_gray
    c.colors.tabs.selected.odd.bg = dark_gray

    c.colors.tabs.selected.even.fg = white
    c.colors.tabs.selected.odd.fg = white

    # Indicator
    c.colors.tabs.indicator.start = mid_gray
    c.colors.tabs.indicator.stop = dark_gray
    c.colors.tabs.indicator.error = black

    # Pinned tabs
    c.colors.tabs.pinned.even.bg = light_gray
    c.colors.tabs.pinned.odd.bg = light_gray

    c.colors.tabs.pinned.even.fg = black
    c.colors.tabs.pinned.odd.fg = black

    c.colors.tabs.pinned.selected.even.bg = dark_gray
    c.colors.tabs.pinned.selected.odd.bg = dark_gray

    c.colors.tabs.pinned.selected.even.fg = white
    c.colors.tabs.pinned.selected.odd.fg = white

    # Hints
    c.colors.hints.bg = white
    c.colors.hints.fg = black
    c.hints.border = "1px solid " + black

    # Completion
    c.colors.completion.item.selected.match.fg = black
    c.colors.completion.match.fg = black
    c.colors.completion.odd.bg = white
    c.colors.completion.even.bg = white
    c.colors.completion.fg = black
    c.colors.completion.category.bg = light_gray
    c.colors.completion.category.fg = black
    c.colors.completion.item.selected.bg = light_gray
    c.colors.completion.item.selected.fg = black

    # Messages
    c.colors.messages.info.bg = white
    c.colors.messages.info.fg = black
    c.colors.messages.error.bg = light_gray
    c.colors.messages.error.fg = black

    # Downloads
    c.colors.downloads.bar.bg = white
    c.colors.downloads.start.bg = light_gray
    c.colors.downloads.start.fg = black
    c.colors.downloads.stop.bg = dark_gray
    c.colors.downloads.stop.fg = white
    c.colors.downloads.error.bg = mid_gray
    c.colors.downloads.error.fg = black

    # Tooltip & webpage
    c.colors.tooltip.bg = white
    c.colors.webpage.bg = white

# def custom_css(c, config):
#     user_css = Path(EINK_WEB_COLORS_PATH).expanduser()
#
#     user_css.write_text(f"""
#         html, body, body > *, #page, #content, main, .container,
#         header, nav, .Header, .AppHeader, [data-color-mode] {{
#           background-color: #ffffff !important;
#           background-image: none !important;
#           color-scheme: light !important;
#         }}
#         * {{
#           background-color: #ffffff !important;
#           color: #000000 !important;
#           border-color: #000000 !important;
#           box-shadow: none !important;
#           text-shadow: none !important;
#           filter: none !important;
#           backdrop-filter: none !important;
#           -webkit-box-shadow: none !important;
#           -webkit-filter: none !important;
#           -webkit-backdrop-filter: none !important;
#         }}
#         * {{
#           color: #000000 !important;
#         }}
#         a {{
#           text-decoration: underline !important;
#         }}
#         a:hover {{
#           color: #000000 !important;
#         }}
#         [data-color-mode="dark"], [data-dark-theme] {{
#           color-scheme: light !important;
#           --color-canvas-default: #ffffff !important;
#           --color-fg-default: #000000 !important;
#         }}
#         * {{
#           background-color: #ffffff !important;
#           color: #000000 !important;
#           border-color: #000000 !important;
#         }}
#         a {{
#           color: #000000 !important;
#           text-decoration: underline !important;
#         }}
#         img, video, svg {{
#           filter: grayscale(100%) contrast(1.2) !important;
#         }}
#     """)
#     c.content.user_stylesheets = [str(user_css)]

def settings(c, config):
    c.colors.webpage.darkmode.contrast = 1.0
    c.colors.webpage.darkmode.enabled = False
    # c.colors.webpage.darkmode.policy.images = "never"
    c.colors.webpage.darkmode.policy.page = "smart"
    c.colors.webpage.preferred_color_scheme = 'light'

def apply_colors(c, config):
    config.set('colors.webpage.darkmode.enabled', False, 'file://*')

    broser_colors(c, config)
    # custom_css(c, config)
    # settings(c, config)

    # c.content.user_stylesheets = [ EINK_WEB_COLORS_PATH ]
    c.content.user_stylesheets = [ ]

    EinkJSToggle().enable_eink_js()

    return c

# We need this to make sure script doesn't fail on startup and works with live reload
# For example: qutebrowser ':config-source ~/.config/qutebrowser/modules/colors.py'
try: 
    apply_colors(c, config)
except NameError:
    pass
# apply_colors(c, config)
