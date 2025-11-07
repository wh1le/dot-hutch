from ..cmd_helper import execute, show_notification
from ..config import CONFIG_PATHS, MONITORS


def eink_commands(profile):
    config = MONITORS["eink"]

    # execute("hyprctl reload")
    execute(f"wal -n --theme {config["theme"]}")
    execute(f"swww img --transition-type none --outputs {config['port']} {config["default_wallpaper"]}")
    execute(f"touch {CONFIG_PATHS["waybar_config"]}")

    show_notification("E-ink connected", "Default settings are applied")
