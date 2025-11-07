import subprocess
from pathlib import Path

from .config import CONFIG_PATHS


def show_notification(title, message):
    subprocess.run(["notify-send", title, message])

def available_profiles():
    kanshi_profiles = execute(r"grep -Eo '^\s*profile\s+\S+' $HOME/.config/kanshi/config | awk '{print $2}' | sort -u")

    return kanshi_profiles.split("\n")


def execute(command, args=[]):
    defaults = dict(
        shell=True,
        capture_output=True,
        text=True,
        check=True
    )
    kwargs = {**defaults, **(args or {})}

    try:
        return subprocess.run(command, **kwargs).stdout.strip()
    except subprocess.CalledProcessError as e:
        message = (e.stderr or str(e)).strip()

        print(f"Error running command '{command}': {message}")
        show_notification("Failed to execute command in scripts", message)

        raise

