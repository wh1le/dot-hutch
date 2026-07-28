# Jobs

setopt AUTO_RESUME     # allow simple commands to resume backgrounded jobs
setopt NO_FLOW_CONTROL # disable start (C-s) and stop (C-q) characters

# Make CTRL-Z background things and unbackground them.
bindkey '^Z' fg-bg
function fg-bg() {
  if [[ $#BUFFER -eq 0 ]]; then
    fg
  else
    zle push-input
  fi
}
zle -N fg-bg
