import subprocess
from pathlib import Path

GREASE_DIR = Path("~/.config/qutebrowser/greasemonkey").expanduser()
ENABLED_PATH = GREASE_DIR / "eink_highcontrast.js"
DISABLED_PATH = GREASE_DIR / "eink_highcontrast.js.disabled"

def enable_eink_js():
    if ENABLED_PATH.exists():
        return 
    else:
        DISABLED_PATH.rename(ENABLED_PATH)

def disable_eink_js():
    if DISABLED_PATH.exists():
        return
    else:
        ENABLED_PATH.rename(DISABLED_PATH)
