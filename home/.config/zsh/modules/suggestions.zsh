ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=59'

mkdir -p "${HOME}/.cache/zsh"
export ZSH_COMPDUMP="${HOME}/.cache/zsh/zcompdump-${ZSH_VERSION}"

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

export ZSH_AUTOSUGGEST_STRATEGY=(history)

source ~/.config/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

mkdir -p "${HOME}/.cache/zsh"
export ZSH_COMPDUMP="${HOME}/.cache/zsh/zcompdump-${ZSH_VERSION}"

# setopt AUTO_PARAM_SLASH # tab completing directory appends a slash
# setopt LIST_PACKED      # make completion lists more densely packed
# setopt MENU_COMPLETE    # auto-insert first possible ambiguous completion
