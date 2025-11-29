ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=59'

source ~/.config/zsh/zsh-autocomplete/zsh-autocomplete.plugin.zsh

mkdir -p "${HOME}/.cache/zsh"
export ZSH_COMPDUMP="${HOME}/.cache/zsh/zcompdump-${ZSH_VERSION}"

setopt AUTO_PARAM_SLASH # tab completing directory appends a slash
setopt LIST_PACKED      # make completion lists more densely packed
setopt MENU_COMPLETE    # auto-insert first possible ambiguous completion
