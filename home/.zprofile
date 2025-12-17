# Props to https://github.com/BreadOnPenguins

# export COLORTERM=truecolor

export EDITOR="nvim"
export VISUAL=nvim
export TERMINAL="kitty"
export BROWSER="firefox"

export PAGER="nvimpager"    # colored man pages
export MANPAGER="nvimpager" # colored man pages

export USER_SCRIPTS_PATH="$HOME/.local/bin/public"
export LAUNCHER_SCRIPTS_PATH="$HOME/.local/bin/public/menu"

export KITTY_LAUNCHER_CLASS="launcher"
export KITTY_LAUNCHER_SOCKET_PATH="/tmp/kitty-launcher"

# export SEARCH_DIRECTORIES_PATHS="$HOME/Projects $HOME/code $HOME/obsidian $HOME/.config $HOME/dot $HOME/.local/bin"
_search_dirs=(
  "$HOME/Projects"
  "$HOME/code"
  "$HOME/obsidian"
  "$HOME/.config"
  "$HOME/dot"
  "$HOME/.local/bin"
  "$HOME/virtualization"
  "$HOME/Music"
  "$HOME/dot/files/home/"
)

export SEARCH_DIRECTORIES_PATHS="${(j/:/)_search_dirs}"

# follow XDG base dir specification
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

export SCREENSHOT_PATH="$HOME/Pictures/screenshots"

# bootstrap .zshrc to ~/.config/zsh/zshrc, any other zsh config files can also reside here
export ZDOTDIR="$XDG_CONFIG_HOME/zsh/"

# history files
export LESSHISTFILE="$XDG_CACHE_HOME/less_history"
export PYTHON_HISTORY="$XDG_DATA_HOME/python/history"

# add scripts to path
# export PATH="$XDG_CONFIG_HOME/scripts:$PATH"
export PATH="$HOME/.local/bin:$HOME/.local/bin/private:$HOME/.local/bin/public:$PATH"

# X11 support for different desktop env
export XINITRC="$XDG_CONFIG_HOME/x11/xinitrc"
export XPROFILE="$XDG_CONFIG_HOME/x11/xprofile"
export XRESOURCES="$XDG_CONFIG_HOME/x11/xresources"

export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc-2.0" # gtk 3 & 4 are XDG compliant
export WGETRC="$XDG_CONFIG_HOME/wget/wgetrc"
export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/pythonrc"
export GNUPGHOME="$XDG_DATA_HOME/gnupg"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export GOPATH="$XDG_DATA_HOME/go"
export GOBIN="$GOPATH/bin"
export GOMODCACHE="$XDG_CACHE_HOME/go/mod"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export GRADLE_USER_HOME="$XDG_DATA_HOME/gradle"
export NUGET_PACKAGES="$XDG_CACHE_HOME/NuGetPackages"
export _JAVA_OPTIONS=-Djava.util.prefs.userRoot="$XDG_CONFIG_HOME/java"
export _JAVA_AWT_WM_NONREPARENTING=1
export PARALLEL_HOME="$XDG_CONFIG_HOME/parallel"
export FFMPEG_DATADIR="$XDG_CONFIG_HOME/ffmpeg"
export WINEPREFIX="$XDG_DATA_HOME/wineprefixes/default"

# NOTE: you messed with the --exact flag for FZF_CTRL_R_OPTS don't forget to add it back or rule out

# colored less + termcap vars
export LESS="R --use-color -Dd+r -Du+b"
export LESS_TERMCAP_mb="$(printf '%b' '[1;31m')"
export LESS_TERMCAP_md="$(printf '%b' '[1;36m')"
export LESS_TERMCAP_me="$(printf '%b' '[0m')"
export LESS_TERMCAP_so="$(printf '%b' '[01;44;33m')"
export LESS_TERMCAP_se="$(printf '%b' '[0m')"
export LESS_TERMCAP_us="$(printf '%b' '[1;32m')"
export LESS_TERMCAP_ue="$(printf '%b' '[0m')"
