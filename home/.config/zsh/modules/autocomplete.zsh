mkdir -p "${HOME}/.cache/zsh"
export ZSH_COMPDUMP="${HOME}/.cache/zsh/zcompdump-${ZSH_VERSION}"

autoload -Uz compinit
# (Nmh-20) expands to the file path if modified within 20 hours, empty otherwise.
# Fast path: load cached compdump without scanning $fpath (~14ms vs ~85ms).
# Slow path: first shell of the day does a full scan to pick up new completions.
local -a fresh=($ZSH_COMPDUMP(Nmh-20))
if (( $#fresh )); then
  compinit -C -d "$ZSH_COMPDUMP"
else
  compinit -d "$ZSH_COMPDUMP"
  touch "$ZSH_COMPDUMP"
fi

# Compile compdump to bytecode (.zwc) in background for faster loading
{
  if [[ -s "$ZSH_COMPDUMP" && (! -s "${ZSH_COMPDUMP}.zwc" || "$ZSH_COMPDUMP" -nt "${ZSH_COMPDUMP}.zwc") ]]; then
    zcompile "$ZSH_COMPDUMP"
  fi
} &!

# Menu-select: Tab opens a visual list, navigate with Tab/Shift-Tab/arrows
zstyle ':completion:*' menu select
zmodload zsh/complist

# Tab/Shift-Tab cycle through the menu, Enter accepts without executing
bindkey -M menuselect '^I' menu-complete
bindkey -M menuselect '^[[Z' reverse-menu-complete
bindkey -M menuselect '^M' accept-search

# Matching: case-insensitive, then partial-word, then substring
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# Group completions by type
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'

# Colors in file completion (uses LS_COLORS)
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
