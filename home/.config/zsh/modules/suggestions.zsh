source ~/.cache/wal/zsh-colors.sh 2>/dev/null || ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=59'

setopt EXTENDED_GLOB
# if [[ -f ~/.filtered_words ]]; then
#     local words=("${(@f)$(< ~/.filtered_words)}")
#     ZSH_AUTOSUGGEST_HISTORY_IGNORE="(#i)*(${(j:|:)words})*"
# fi
#
# if [[ -f ~/.filtered_words ]]; then
#   local pattern=$(tr '\n' '|' <~/.filtered_words | sed 's/|$//')
#   ZSH_AUTOSUGGEST_HISTORY_IGNORE="(#i)*($pattern)*"
#
#   HISTORY_IGNORE="(#i)*($pattern)*"
#
#   FILTERED_PATTERN="(#i).*($pattern).*"
#
#   # Filter history - prevent matching commands from being saved
#   zshaddhistory() {
#     [[ ! $1 =~ $~FILTERED_PATTERN ]]
#   }
# fi

# if [[ -f ~/.filtered_words ]]; then
#     local words=("${(@f)$(< ~/.filtered_words)}")
#     ZSH_AUTOSUGGEST_HISTORY_IGNORE="*(${(j:|:)words})*"
# fi

source ~/.config/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# Custom strategy: import new history from file before searching
# so commands from other tmux panes appear in suggestions
_zsh_autosuggest_strategy_history_synced() {
  fc -RI
  _zsh_autosuggest_strategy_history "$@"
}

export ZSH_AUTOSUGGEST_STRATEGY=(history_synced)

# setopt AUTO_PARAM_SLASH # tab completing directory appends a slash
# setopt LIST_PACKED      # make completion lists more densely packed
# setopt MENU_COMPLETE    # auto-insert first possible ambiguous completion
