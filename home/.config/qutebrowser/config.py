c = c 
config = config  # noqa: F821 pylint: disable=E0602,C0103
config.source('colors.py')

import subprocess

from colors import apply_colors

c = apply_colors(c)

# c.url.start_pages = ""
# c.url.default_page = ""

c.fonts.web.size.default = 18

c.url.searchengines = {
    'DEFAULT': 'https://duckduckgo.com/?q={}',
    '!aw': 'https://wiki.archlinux.org/?search={}',
    '!apkg': 'https://archlinux.org/packages/?sort=&q={}&maintainer=&flagged=',
    '!gh': 'https://github.com/search?o=desc&q={}&s=stars',
    '!yt': 'https://www.youtube.com/results?search_query={}',
}

c.completion.open_categories = [
    'searchengines',
    'quickmarks',
    'bookmarks',
    'history',
    'filesystem'
]

config.load_autoconfig()
c.statusbar.show = "always"

c.auto_save.session = True

c.scrolling.smooth = True

# keybinding changes
config.bind('=', 'cmd-set-text -s :open')
# config.bind('h', 'history')
# config.bind('cc', 'hint images spawn sh -c "cliphist link {hint-url}"')
# config.bind('cs', 'cmd-set-text -s :config-source')
# config.bind('tH', 'config-cycle tabs.show multiple never')
# config.bind('sH', 'config-cycle statusbar.show always never')
# config.bind('T', 'hint links tab')
# config.bind('pP', 'open -- {primary}')
# config.bind('pp', 'open -- {clipboard}')
# config.bind('pt', 'open -t -- {clipboard}')
# config.bind('qm', 'macro-record')
# config.bind('<ctrl-y>', 'spawn --userscript ytdl.sh')
# config.bind('tT', 'config-cycle tabs.position top left')
config.bind('<Ctrl-j>', 'tab-move +')
config.bind('<Ctrl-k>', 'tab-move -')
config.bind('<Ctrl-h>', 'back')
config.bind('<Ctrl-l>', 'forward')
# config.bind("<Alt-t>", "config-cycle tabs.min_width 80 300")
config.bind('M', "spawn --detach mpv --ytdl-format='bestvideo+bestaudio' {url}")

config.set('colors.webpage.darkmode.enabled', False, 'file://*')

c.colors.webpage.darkmode.enabled = True
c.colors.webpage.darkmode.policy.images = "never"
c.colors.webpage.darkmode.policy.page = "smart"

# c.content.user_stylesheets = ["~/.config/qutebrowser/styles/youtube-tweaks.css"]

c.tabs.show = "multiple"

c.tabs.title.format = "{index}: {current_title}"  # default
c.tabs.title.format = "{index}"                   # compact - number only
c.tabs.title.format = "{current_title:.15}"       # compact - truncated title

c.tabs.padding = {'top': 9, 'bottom': 5, 'left': 9, 'right': 5}
c.tabs.indicator.width = 5 # no tab indicators

c.content.autoplay = False

c.editor.command = ["nvim", "-f", "{file}", "-c", "normal {line}G{column0}l"]


c.content.headers.do_not_track = True
c.content.cookies.accept = "no-3rdparty"

# c.tabs.width = 200        # fixed width in pixels
c.tabs.min_width = 80     # minimum when shrinking
c.tabs.max_width = 300    # maximum width

c.zoom.default = "90%"
c.tabs.position = "right"
# c.tabs.width = 36
# c.tabs.show = "multiple"
# c.tabs.max_width = 240
# c.tabs.min_width = 100
# c.tabs.favicons.show = "always"
# c.tabs.padding = {"top": 8, "bottom": 8, "left": 6, "right": 5}
# c.tabs.indicator.width = 2 
# c.tabs.wrap = True
# c.tabs.last_close = "default-page"

c.fonts.tabs.selected = "10pt Iosevka Nerd Font Mono"
c.fonts.tabs.unselected = "10pt Iosevka Nerd Font Mono"

# fonts
c.fonts.default_family = ["Iosevka Nerd Font Mono"]
c.fonts.web.family.fixed = 'monospace'
c.fonts.web.family.sans_serif = 'monospace'
c.fonts.web.family.serif = 'monospace'
c.fonts.web.family.standard = 'monospace'

# privacy - adjust these settings based on your preference
# config.set("completion.cmd_history_max_items", 0)
# config.set("content.private_browsing", True)
# config.set("content.javascript.enabled", False) # tsh keybind to toggle
config.set("content.webgl", False, "*")
config.set("content.canvas_reading", False)
config.set("content.geolocation", False)
config.set("content.webrtc_ip_handling_policy", "default-public-interface-only")
config.set("content.cookies.accept", "all")
config.set("content.cookies.store", True)


# Adblocking info -->
# For yt ads: place the greasemonkey script yt-ads.js in your greasemonkey folder (~/.config/qutebrowser/greasemonkey).
# You can also watch yt vids directly in mpv, see qutebrowser FAQ for how to do that.
c.content.blocking.enabled = True
c.content.blocking.method = 'adblock'
c.content.blocking.adblock.lists = [
    "https://github.com/uBlockOrigin/uAssets/raw/master/filters/legacy.txt",
    "https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters.txt",
    "https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters-2020.txt",
    "https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters-2021.txt",
    "https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters-2022.txt",
    "https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters-2023.txt",
    "https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters-2024.txt",
    "https://github.com/uBlockOrigin/uAssets/raw/master/filters/badware.txt",
    "https://github.com/uBlockOrigin/uAssets/raw/master/filters/privacy.txt",
    "https://github.com/uBlockOrigin/uAssets/raw/master/filters/badlists.txt",
    "https://github.com/uBlockOrigin/uAssets/raw/master/filters/annoyances.txt",
    "https://github.com/uBlockOrigin/uAssets/raw/master/filters/annoyances-cookies.txt",
    "https://github.com/uBlockOrigin/uAssets/raw/master/filters/annoyances-others.txt",
    "https://github.com/uBlockOrigin/uAssets/raw/master/filters/badlists.txt",
    "https://github.com/uBlockOrigin/uAssets/raw/master/filters/quick-fixes.txt",
    "https://github.com/uBlockOrigin/uAssets/raw/master/filters/resource-abuse.txt",
    "https://github.com/uBlockOrigin/uAssets/raw/master/filters/unbreak.txt"
]

