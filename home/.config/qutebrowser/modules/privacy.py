def apply_privacy(c, config):
    c.content.headers.do_not_track = True
    c.content.cookies.accept = "no-3rdparty"
    config.set("content.geolocation", False)

    # config.set("completion.cmd_history_max_items", 0)
    config.set( "content.headers.user_agent", "Mozilla/5.0 (Windows NT 10.0; rv:68.0) Gecko/20100101 Firefox/68.0")
    config.set("content.headers.accept_language", "en-US,en;q=0.5")
    config.set("content.headers.custom", {
        "accept": "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"
    })

