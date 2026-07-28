# Edit command in editor (temp file in $PWD so path completion works)
function edit-command-line-cwd() {
  local tmpfile=$(mktemp "${PWD}/.zsh-edit-XXXXXX.zsh")
  print -r -- "$BUFFER" > "$tmpfile"
  "${(@Q)${(z)${VISUAL:-${EDITOR:-vi}}}}" "$tmpfile" < /dev/tty
  BUFFER=$(<"$tmpfile")
  CURSOR=$#BUFFER
  command rm -f "$tmpfile"
  zle reset-prompt
}
zle -N edit-command-line-cwd
bindkey '^x^x' edit-command-line-cwd
