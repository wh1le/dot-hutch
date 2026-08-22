# Edit command in editor (temp file in $PWD so path completion works)
function edit-command-line-cwd() {
  command rm -f "${PWD}"/.zsh-edit-*.zsh
  local tmpfile=$(mktemp "${PWD}/.zsh-edit-XXXXXX.zsh")
  trap "command rm -f ${(q)tmpfile}" EXIT INT TERM
  print -r -- "$BUFFER" > "$tmpfile"
  "${(@Q)${(z)${VISUAL:-${EDITOR:-vi}}}}" "$tmpfile" < /dev/tty
  BUFFER=$(<"$tmpfile")
  CURSOR=$#BUFFER
  command rm -f "$tmpfile"
  trap - EXIT INT TERM
  zle reset-prompt
}
zle -N edit-command-line-cwd
bindkey '^x^x' edit-command-line-cwd
