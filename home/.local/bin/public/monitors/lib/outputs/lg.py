from ..cmd_helper import execute, show_notification
from ..config import CONFIG_PATHS, MONITORS


def lg_commands(profile):
    config = MONITORS["lg"]

    if profile == "home":
        execute(f"swww img --resize fit  --outputs {config["port"]} {config["default_wallpaper"]}")
    else:
        execute(f"swww img --outputs  {config["port"]} {config["default_wallpaper"]}")

    execute(f"touch {CONFIG_PATHS["waybar_config"]}")

    show_notification("Kanshi", "LG connected on $LG_MONITOR and settings applied")
