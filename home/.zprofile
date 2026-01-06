export EDITOR="nvim"
export VISUAL=nvim
export TERMINAL="kitty"
export BROWSER="qutebrowser"

export PAGER="nvimpager"
export MANPAGER="nvimpager"

export USER_SCRIPTS_PATH="$HOME/.local/bin/public"
export LAUNCHER_SCRIPTS_PATH="$HOME/.local/bin/public/menu"

export KITTY_LAUNCHER_CLASS="launcher"
export KITTY_LAUNCHER_SOCKET_PATH="/tmp/kitty-launcher"
export KITTY_LAUNCHER_FZF_PATH="$LAUNCHER_SCRIPTS_PATH/helpers/fzf-with-options"
export KITTY_LAUNCHER_SCRIPTS_PATH="$LAUNCHER_SCRIPTS_PATH/options"

export SCREENSHOT_PATH="$HOME/Pictures/screenshots"

export NIX_BUILD_SHELL=zsh

_search_dirs=(
  "$HOME/Projects"
  "$HOME/code"
  "$HOME/Obsidian"
  "$HOME/.config"
  "$HOME/dot"
  "$HOME/.local/bin"
  "$HOME/.local/bin/public"
  "$HOME/.local/bin/private"
  "$HOME/virtualization"
  "$HOME/Music"
  "$HOME/Documents"
  "$HOME/dot/files/home/"
  "/mnt"
)

export SEARCH_DIRECTORIES_PATHS="$(IFS=:; echo "${_search_dirs[*]}")"

export PASSWORD_STORE_DIR="$HOME/.secrets/passwords"
export SOPS_AGE_KEY_FILE="/var/lib/sops-nix/key.txt"

# history files
export LESSHISTFILE="$HOME/.less_history"
export PYTHON_HISTORY="$HOME/.python_history"

# PATH
export PATH="$HOME/.local/bin:$HOME/.local/bin/private:$HOME/.local/bin/public:$PATH"

# fllow XDG dir specification
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export ZDOTDIR="$XDG_CONFIG_HOME/zsh/"
export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc-2.0"
export WGETRC="$XDG_CONFIG_HOME/wget/wgetrc"
export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/pythonrc"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export GOPATH="$XDG_DATA_HOME/go"
export GOBIN="$GOPATH/bin"
export GOMODCACHE="$XDG_CACHE_HOME/go/mod"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export FFMPEG_DATADIR="$XDG_CONFIG_HOME/ffmpeg"
export WINEPREFIX="$XDG_DATA_HOME/wineprefixes/default"

# First boot
if [ ! -d "$HOME/.cache/wal" ]; then
  wal -esnti $HOME/.current_wallpaper
fi
