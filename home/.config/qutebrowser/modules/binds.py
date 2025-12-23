def apply_binds(c, config):
    # keybinding changes
    # config.bind('=', 'cmd-set-text -s :open')
    config.bind('h', 'history')
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

    # config.bind("<Alt-t>", "config-cycle tabs.min_width 80 300")

    config.bind('M', "spawn --detach mpv --ytdl-format='bestvideo+bestaudio' {url}")

    # tabs
    config.bind('<Ctrl-p>', 'tab-pin ;; tab-move')
    config.bind('<Ctrl-j>', 'tab-next')
    config.bind('<Ctrl-k>', 'tab-prev')

    config.bind('<Ctrl-u>', 'edit-url')

    config.bind('<Ctrl-Shift-j>', 'tab-move +')
    config.bind('<Ctrl-Shift-k>', 'tab-move -')

    # navigation
    config.bind('<Ctrl-h>', 'back')
    config.bind('<Ctrl-l>', 'forward')

    config.bind('T', 'cmd-set-text -s :open -t {url}')

    # passthrough
    config.unbind('<Ctrl-v>')
    config.bind('<Shift-Escape>', 'mode-enter passthrough')
    config.bind('<Shift-Escape>', 'mode-leave', mode='passthrough')

    # passwords
    c.qt.environ = {
        'PASSWORD_STORE_DIR': '/home/wh1le/.secrets/passwords',
    }

    config.bind('<z><l>', 'spawn --userscript qute-pass --unfiltered --username-target secret --username-pattern "login: (.+)" --dmenu-invocation /home/wh1le/.local/bin/public/menu/launch-dmenu')
    config.bind('<z><u>', 'spawn --userscript qute-pass --unfiltered --username-only --username-target secret --username-pattern "login: (.+)" --dmenu-invocation /home/wh1le/.local/bin/public/menu/launch-dmenu')
    config.bind('<z><p>', 'spawn --userscript qute-pass --unfiltered --password-only --dmenu-invocation /home/wh1le/.local/bin/public/menu/launch-dmenu')
