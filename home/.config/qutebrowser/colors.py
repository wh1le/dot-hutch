import json
from pathlib import Path


def read_pywal():
    wal_path = Path.home() / ".cache/wal/colors.json"
    with open(wal_path) as f:
        return json.load(f)

def apply_colors(c):
    wal = read_pywal()

    # c.colors.statusbar.normal.bg = "#00000000"
    # c.colors.statusbar.command.bg = "#00000000"
    # c.colors.statusbar.command.fg = wal["special"]["foreground"]
    # c.colors.statusbar.normal.fg = wal["colors"]["color14"]

    c.colors.statusbar.url.fg = wal["colors"]["color13"]
    c.colors.statusbar.url.success.https.fg = wal["colors"]["color13"]
    c.colors.statusbar.url.hover.fg = wal["colors"]["color12"]

    c.colors.statusbar.normal.bg = wal["special"]["background"]
    c.colors.statusbar.normal.fg = wal["colors"]["color7"]

    c.colors.statusbar.command.bg = wal["colors"]["color0"]
    c.colors.statusbar.command.fg = wal["colors"]["color4"]  

    c.colors.statusbar.insert.bg = wal["colors"]["color2"]  
    c.colors.statusbar.insert.fg = wal["colors"]["color0"]

    c.colors.statusbar.passthrough.bg = wal["colors"]["color5"]  
    c.colors.statusbar.passthrough.fg = wal["colors"]["color0"]

    c.colors.statusbar.private.bg = wal["colors"]["color1"]  
    c.colors.statusbar.private.fg = wal["colors"]["color0"]

    c.colors.statusbar.caret.bg = wal["colors"]["color6"]   
    c.colors.statusbar.caret.fg = wal["colors"]["color0"]
    c.colors.statusbar.caret.selection.bg = wal["colors"]["color3"]  
    c.colors.statusbar.caret.selection.fg = wal["colors"]["color0"]

    # c.colors.tabs.even.bg = "#00000000" # transparent tabs!!
    # c.colors.tabs.odd.bg = "#00000000"
    # c.colors.tabs.bar.bg = "#00000000"
    # c.colors.tabs.even.fg = wal["colors"]["color0"]
    # c.colors.tabs.odd.fg = wal["colors"]["color0"]
    # c.colors.tabs.selected.even.bg = wal["special"]["foreground"]
    # c.colors.tabs.selected.odd.bg = wal["special"]["foreground"]
    # c.colors.tabs.selected.even.fg = wal["special"]["background"]
    # c.colors.tabs.selected.odd.fg = wal["special"]["background"]

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
    c.colors.tabs.pinned.even.fg = wal["colors"]["color6"]
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

    return c
