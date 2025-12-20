
from modules.add_block import apply_add_block
from modules.binds import apply_binds
from modules.colors import apply_colors
from modules.commands import apply_commands
from modules.fonts import apply_fonts
from modules.general import apply_general
from modules.privacy import apply_privacy
from modules.search_engines import apply_search_engines

c = c # noqa: F821
config = config # noqa: F821

apply_add_block(c, config)
apply_binds(c, config)
apply_colors(c, config)
apply_commands(c, config)
apply_fonts(c, config)
apply_general(c, config)
apply_privacy(c, config)
apply_search_engines(c, config)

config.load_autoconfig()

# c.url.start_pages = ""
# c.url.default_page = ""
