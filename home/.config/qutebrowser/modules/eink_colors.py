import json
from pathlib import Path


def read_pywal():
    wal_path = Path.home() / ".cache/wal/colors.json"
    with open(wal_path) as f:
        return json.load(f)

def apply_colors(c, config):
    wal = read_pywal()
    config.set('colors.webpage.darkmode.enabled', False, 'file://*')
    c.colors.webpage.preferred_color_scheme = "light"
    c.colors.webpage.darkmode.contrast = 1.0

    # EINK: Disable dark mode for e-ink display
    c.colors.webpage.darkmode.enabled = False
    c.colors.webpage.darkmode.policy.images = "never"
    c.colors.webpage.darkmode.policy.page = "smart"

    # EINK colors
    black = "#000000"
    white = "#ffffff"
    light_gray = "#cccccc"
    mid_gray = "#888888"
    dark_gray = "#444444"

    c.colors.statusbar.url.fg = dark_gray
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

    c.colors.tabs.even.fg = mid_gray
    c.colors.tabs.odd.fg = mid_gray

    c.colors.tabs.selected.even.bg = black
    c.colors.tabs.selected.odd.bg = black
    c.colors.tabs.selected.even.fg = white
    c.colors.tabs.selected.odd.fg = white

    # Indicator
    c.colors.tabs.indicator.start = mid_gray
    c.colors.tabs.indicator.stop = dark_gray
    c.colors.tabs.indicator.error = black

    # Pinned tabs
    c.colors.tabs.pinned.even.bg = light_gray
    c.colors.tabs.pinned.even.fg = black
    c.colors.tabs.pinned.odd.bg = light_gray
    c.colors.tabs.pinned.odd.fg = black

    c.colors.tabs.pinned.selected.even.bg = black
    c.colors.tabs.pinned.selected.odd.bg = black
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

    # User CSS for eink
    user_css = Path("~/.config/qutebrowser/user.css").expanduser()

    user_css.write_text(f"""
        html, body, body > *, #page, #content, main, .container,
        header, nav, .Header, .AppHeader, [data-color-mode] {{
          background-color: #ffffff !important;
          background-image: none !important;
          color-scheme: light !important;
        }}
        * {{
          background-color: #ffffff !important;
          color: #000000 !important;
          border-color: #000000 !important;
          box-shadow: none !important;
          text-shadow: none !important;
          filter: none !important;
          backdrop-filter: none !important;
          -webkit-box-shadow: none !important;
          -webkit-filter: none !important;
          -webkit-backdrop-filter: none !important;
        }}
        * {{
          color: #000000 !important;
        }}
        a {{
          color: #444444 !important;
          text-decoration: underline !important;
        }}
        a:hover {{
          color: #000000 !important;
        }}
        [data-color-mode="dark"], [data-dark-theme] {{
          color-scheme: light !important;
          --color-canvas-default: #ffffff !important;
          --color-fg-default: #000000 !important;
        }}
        * {{
          background-color: #ffffff !important;
          color: #000000 !important;
          border-color: #000000 !important;
        }}
        a {{
          color: #000000 !important;
          text-decoration: underline !important;
        }}
        img, video, svg {{
          filter: grayscale(100%) contrast(1.2) !important;
        }}
    """)
    
    c.content.user_stylesheets = [str(user_css)]

    return c

apply_colors(c, config)
