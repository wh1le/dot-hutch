def apply_search_engines(c, config):
    c.url.searchengines = {
        'DEFAULT': 'https://duckduckgo.com/?q={}',
        '!d':  'https://duckduckgo.com/?q={}',
        '!g':  'https://www.google.com/search?q={}',
        '!aw': 'https://wiki.archlinux.org/?search={}',
        '!gh': 'https://github.com/search?o=desc&q={}&s=stars',
        '!yt': 'https://www.youtube.com/results?search_query={}',
        '!cl': 'https://claude.ai/new?q={}',
        '!r':  'https://www.reddit.com/search/?q={}',

        # nix
        '!np': 'https://search.nixos.org/packages?query={}',
        '!no': 'https://search.nixos.org/options?query={}',
    }
