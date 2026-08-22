export EDITOR="nvim"
export VISUAL=nvim
export TERMINAL="ghostty"
if [[ "$(uname -s)" == "Darwin" ]]; then
  export BROWSER="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
else
  export BROWSER="firefox"
fi

export PAGER="less"
export MANPAGER="less"

export USER_SCRIPTS_PATH="$HOME/.local/bin/public"
export LAUNCHER_SCRIPTS_PATH="$HOME/.local/bin/public/menu"

# export EJSON_KEYDIR=~/.secrets/ejson

export SCREENSHOT_PATH="$HOME/Pictures/screenshots"
export SOUND_THEME_PATH="/run/current-system/sw/share/sounds/ocean/stereo"

export PYTHON_KEYRING_BACKEND=keyring.backends.null.Keyring

export GDK_SCALE=1
export QT_ENABLE_HIGHDPI_SCALING=1
export QT_AUTO_SCREEN_SCALE_FACTOR=1
export QT_QPA_PLATFORMTHEME="qt6ct"

export CURRENT_WALLPAPER="$HOME/.current_wallpaper"
export user_themes_path="$HOME/.config/saved_themes/"

_search_dirs=(
  "$HOME"
  "$HOME/Code"
  "$HOME/Projects"
  "$HOME/Code/tmp"
  "$HOME/Code/zendesk"
  "$HOME/.local/bin"
  "$HOME/.local/bin/public"
  "$HOME/.local/bin/personal"
  "$HOME/.local/bin/work"
  "$HOME/Obsidian"
  "$HOME/Music"
  "$HOME/Documents"
  "$HOME/Virtualization"
  "$HOME/.config"
  "$HOME/Interviews"
  "$HOME/Llm/models"
  "$HOME/.sync"
)

export SEARCH_DIRECTORIES_PATHS="$(
  IFS=:
  for _d in "${_search_dirs[@]}"; do [ -d "$_d" ] && printf '%s:' "$_d"; done
)"

export PASSWORD_STORE_DIR="$HOME/.secrets/passwords"
export SOPS_AGE_KEY_FILE="/var/lib/sops-nix/keys.txt"

export LESSHISTFILE="$HOME/.less_history"
export PYTHON_HISTORY="$HOME/.python_history"

export PATH="$PATH:$HOME/.local/bin:$HOME/.local/bin/work-zendesk:$HOME/.local/bin/personal:$HOME/.local/bin/public:$HOME/.local/bin/code:$HOME/.local/bin/distrobox:$HOME/.local/share/cargo/bin"

export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_DESKTOP_DIR="$HOME/Desktop"
export XDG_DOCUMENTS_DIR="$HOME/Documents"
export XDG_DOWNLOAD_DIR="$HOME/Downloads"
export XDG_MUSIC_DIR="$HOME/Music"
export XDG_PICTURES_DIR="$HOME/Pictures"
export XDG_TEMPLATES_DIR="$HOME/Templates"
export XDG_VIDEOS_DIR="$HOME/Videos"

export ZDOTDIR="$XDG_CONFIG_HOME/zsh/"
export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc-2.0"
export WGETRC="$XDG_CONFIG_HOME/wget/wgetrc"
export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/pythonrc"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export GOPATH="$XDG_DATA_HOME/go"
export GOBIN="$GOPATH/bin"
export GOMODCACHE="$XDG_CACHE_HOME/go/mod"
# TODO: Fails on working machine, figure out later
# export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export FFMPEG_DATADIR="$XDG_CONFIG_HOME/ffmpeg"
export WINEPREFIX="$XDG_DATA_HOME/wineprefixes/default"

export MOZ_DISABLE_RDD_SANDBOX=1
export MOZ_GFX_BACKEND=vulkan
export MOZ_WEBRENDER=1
export MOZ_WEBRENDER=1

if [ -z "$DISPLAY" ] && [ -z "$TMUX" ] && [ "$XDG_VTNR" = 1 ] && [ "$(tty)" = "/dev/tty1" ]; then
  exec startx "$HOME/.config/x11/xinitrc"
fi
