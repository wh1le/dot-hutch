def apply_fonts(c, config):
    c.fonts.web.size.default  = 18

    c.fonts.tabs.selected     = "10pt Iosevka Nerd Font Mono"
    c.fonts.tabs.unselected   = "10pt Iosevka Nerd Font Mono"

    c.fonts.default_family    = ["Iosevka Nerd Font Mono"]

    c.fonts.web.family.cursive = 'Atkinson Hyperlegible'
    c.fonts.web.family.fantasy = 'Atkinson Hyperlegible'
    c.fonts.web.family.fixed = '16 Iosevka Nerd Font Mono'
    c.fonts.web.family.sans_serif = 'Atkinson Hyperlegible'
    c.fonts.web.family.serif = 'Atkinson Hyperlegible'
    c.fonts.web.family.standard = 'Atkinson Hyperlegible'

    # config.set("fonts.web.family.standard", "Iosevka Nerd Font Mono", "*://*/*")
    # config.set("fonts.web.size.default", 18, "*://*/*")

    # c.fonts.web.family.fixed      = 'monospace'
    # c.fonts.web.family.sans_serif = 'monospace'
    # c.fonts.web.family.serif      = 'monospace'
    # c.fonts.web.family.standard   = 'monospace'
