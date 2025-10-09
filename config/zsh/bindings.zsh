bindkey -e

bindkey "^a" beginning-of-line
bindkey "^e" end-of-line
bindkey "^b" backward-word
bindkey "^f" forward-word

bindkey "^w" backward-kill-word
bindkey "^k" kill-word

export FZF_CTRL_R_OPTS='--exact --no-sort'
bindkey '^r' fzf-history-widget

#
# Make CTRL-Z background things and unbackground them.
#
bindkey '^Z' fg-bg
function fg-bg() {
  if [[ $#BUFFER -eq 0 ]]; then
    fg
  else
    zle push-input
  fi
}
zle -N fg-bg


#
# Spawn fzf and jump to editor with filename
#
function fzf-quick-edit() {
  local dir file
  if git rev-parse --show-toplevel &>/dev/null; then
    dir=$(git rev-parse --show-toplevel)
  else
    dir=.
  fi
  file=$(git ls-files --cached --others --exclude-standard 2>/dev/null | fzf --no-sort --tac --prompt="edit> " --bind=ctrl-z:abort --ansi --height=40% --border=rounded --query="$LBUFFER") || return
  [[ -n $file ]] && "$EDITOR" "$dir/$file"
  zle redisplay
}
zle -N fzf-quick-edit
bindkey '^d' fzf-quick-edit


#
# Edit command in editor
#
autoload -U edit-command-line
zle -N edit-command-line
bindkey '^x^x' edit-command-line
# --

