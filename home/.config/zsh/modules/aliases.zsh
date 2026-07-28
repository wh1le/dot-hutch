# vimlike
alias :e=nvim
alias :sp='test -n "$TMUX" && tmux split-window'
alias :vs='test -n "$TMUX" && tmux split-window -h'
alias :qa=exit
alias :wq=exit

# Ruby
alias b=bundle
alias be='bundle exec'

alias python-watch="helper-python-watch"

# Tmux
alias ta="tmux attach"

alias vim="nvim"
alias freespace="ncdu -x"

function show-font-styles() {
  # "JetBrainsMono Nerd Font Mono"
  fc-list $1 -f '%{style}\n' | sed 's/,/\n/g' | sort -u
}

alias slogs="sudo journalctl -u"
alias status="sudo systemctl status"

alias copy="rsync -ah --info=progress2 --stats"

alias fspace="ncdu -x /"

# excalidraw
alias excalidraw-edit='node ~/Code/git-excalidraw-edit/src/cli.js'

# npm
function npm-publish() {
  local token_path="${1:-npm/access_token}"
  npm publish --//registry.npmjs.org/:_authToken="$(pass "$token_path")"
}
