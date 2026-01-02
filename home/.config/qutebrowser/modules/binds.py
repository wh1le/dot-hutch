def apply_binds(c, config):

    # ##############################################################
    # Some left overs from initial configuration let them be to see if I can use some of them
    # ##############################################################

    # config.bind('=', 'cmd-set-text -s :open')
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
    # config.bind('M', "spawn --detach mpv --ytdl-format='bestvideo+bestaudio' {url}")

    # ##############################################################
    # Unbind commands I trigger by accident
    # ##############################################################

    config.unbind('d')

    # ##############################################################
    # Custom
    # ##############################################################

    # select all page and enter insert mode right away
    config.bind('<Ctrl-a>', 'mode-enter insert ;; fake-key <Ctrl-a> ;; mode-leave', mode='normal')
    # enter insert mode to paste
    config.bind('<Ctrl-v>', 'mode-enter insert ;; fake-key <Ctrl-v>', mode='normal')

    # open same url in a new tab with eiditing
    config.bind('T', 'cmd-set-text -s :open -t {url}')
    # edit current url in $EDITOR
    config.bind('<Ctrl-u>', 'edit-url')
    # History navigation
    config.bind('<Ctrl-h>', 'back')
    config.bind('<Ctrl-l>', 'forward')

    # ##############################################################
    # Tabs
    # ##############################################################

    config.bind('<Ctrl-Shift-j>', 'tab-move +')
    config.bind('<Ctrl-Shift-k>', 'tab-move -')
    config.bind('<Ctrl-j>', 'tab-next')
    config.bind('<Ctrl-k>', 'tab-prev')
    config.bind('<Ctrl-p>', 'tab-pin ;; tab-move')
    config.bind('<Ctrl-d>', 'tab-close')

    # ##############################################################
    # Passthrough
    # ##############################################################
    config.unbind('<Ctrl-v>')
    config.bind('<Ctrl-q>', 'mode-enter passthrough')
    config.bind('<Ctrl-q>', 'mode-leave', mode='passthrough')
    config.bind('<Ctrl-[>', 'mode-leave', mode='passthrough')

    # ##############################################################
    # User scripts
    # ##############################################################

    # Open MPV (not working as I wanted. still pulls very high quality and takes a lot to buffer video)
    config.bind('<Ctrl-m>', ':spawn --userscript view_in_mpv')

    # ##############################################################
    # Passwords & OTP
    # ##############################################################

    config.bind('<z><l>', 'spawn --userscript qute-pass --unfiltered --username-target secret --username-pattern "login: (.+)" --dmenu-invocation /home/wh1le/.local/bin/public/menu/launch-dmenu')
    config.bind('<z><u>', 'spawn --userscript qute-pass --unfiltered --username-only --username-target secret --username-pattern "login: (.+)" --dmenu-invocation /home/wh1le/.local/bin/public/menu/launch-dmenu')
    config.bind('<z><p>', 'spawn --userscript qute-pass --unfiltered --password-only --dmenu-invocation /home/wh1le/.local/bin/public/menu/launch-dmenu')

    # TODO: Either change otp python userscript (avoidable) or update existing OTP entries to match notation
    # config.bind('<z><o>', 'spawn --userscript qute-pass --unfiltered --otp-only --dmenu-invocation /home/wh1le/.local/bin/public/menu/launch-dmenu')
