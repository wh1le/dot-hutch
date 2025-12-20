def apply_general(c, config):
    # statusbar
    c.statusbar.show = "always"
    c.statusbar.widgets = ['keypress', 'url', 'scroll', 'history', 'tabs', 'progress']

    # tabs
    c.tabs.show = "always"
    c.tabs.title.format = "{index}: {current_title}"  # default
    c.tabs.padding = {'top': 9, 'bottom': 5, 'left': 9, 'right': 5}
    c.tabs.indicator.width = 5 # no tab indicators
    c.tabs.min_width = 80     # minimum when shrinking
    c.tabs.max_width = 300    # maximum width
    c.tabs.position = "right"
    c.tabs.title.format_pinned = "{index}"
    c.tabs.pinned.shrink = True        # Shrink to content width
    c.tabs.pinned.frozen = True        # Lock URL (can't navigate away)
    c.tabs.title.format_pinned = "{index}"  # Show only index
    c.tabs.background = True
    c.tabs.last_close = 'blank'

    c.zoom.default = "90%"
    c.scrolling.smooth = True
    c.auto_save.session = True
    c.session.lazy_restore = True

    # content
    c.content.autoplay = False
    c.content.pdfjs = True
    config.set("content.webgl", False, "*")
    config.set("content.canvas_reading", False)
    config.set("content.cookies.accept", "all")
    config.set("content.cookies.store", True)
    config.set("content.webrtc_ip_handling_policy", "default-public-interface-only")

    c.completion.open_categories = ['searchengines', 'quickmarks', 'bookmarks', 'history', 'filesystem' ]

