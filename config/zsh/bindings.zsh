bindkey -e

bindkey "^a" beginning-of-line
bindkey "^e" end-of-line
bindkey "^b" backward-word
bindkey "^f" forward-word

bindkey "^w" backward-kill-word
bindkey "^k" kill-word

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
  directory=${1:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}

  echo $directory
  #
  # dir=
  #
  # if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  #   echo "in a git repo"
  # else
  #   echo "not in git repo"
  # fi
  #
  # sel=$(git -C "$dir" ls-files --cached --others --exclude-standard | fzf --prompt='edit> ') || return
  # nvim "$dir/$sel"

  # zle redisplay
}
# function fzf-quick-edit() {
#   local dir file
#
#   if git rev-parse --show-toplevel &>/dev/null; then
#     dir=$(git rev-parse --show-toplevel)
#   else
#     dir=.
#   fi
#
#   file=$(git ls-files --cached --others --exclude-standard 2>/dev/null | fzf --no-sort --tac --prompt="edit> " --bind=ctrl-z:abort --ansi --height=40% --border=rounded --query="$LBUFFER") || return
#
#   [[ -n $file ]] && "$EDITOR" "$dir/$file"
#
#   zle redisplay
# }
zle -N fzf-quick-edit
bindkey '^d' fzf-quick-edit


#
# Edit command in editor
#
autoload -U edit-command-line
zle -N edit-command-line
bindkey '^x^x' edit-command-line
# --

