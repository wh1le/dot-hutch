export DIRENV_LOG_FORMAT=""
export DIRENV_CONFIG="$HOME/.config/direnv"

source "$HOME/.cache/zsh/direnv-init.zsh" 2>/dev/null || eval "$(direnv hook zsh)"
