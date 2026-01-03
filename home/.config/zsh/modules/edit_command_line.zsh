zle -N fzf-quick-edit
bindkey '^d' fzf-quick-edit

# Edit command in editor
autoload -U edit-command-line
zle -N edit-command-line
bindkey '^x^x' edit-command-line
