alias :e=nvim
alias :sp='test -n "$TMUX" && tmux split-window'
alias :vs='test -n "$TMUX" && tmux split-window -h'
alias :qa=exit
alias :wq=exit

alias b=bundle
alias be='bundle exec'

alias python-watch="helper-python-watch"

alias ta="tmux attach"

alias vim="nvim"
alias freespace="ncdu -x"

function show-font-styles() {
	fc-list $1 -f '%{style}\n' | sed 's/,/\n/g' | sort -u
}

alias slogs="sudo journalctl -u"
alias status="sudo systemctl status"

alias copy="rsync -ah --info=progress2 --stats"

alias fspace="ncdu -x /"

alias excalidraw-edit='node ~/Code/git-excalidraw-edit/src/cli.js'

function npm-publish() {
	local token_path="${1:-npm/access_token}"
	npm publish --//registry.npmjs.org/:_authToken="$(pass "$token_path")"
}

function expose-port() {
	[[ $# == 1 && $1 == <1-65535> ]] || {
		print -u2 'Usage: expose-port PORT (1-65535)'
		return 2
	}
	sudo iptables -w -C INPUT -p tcp --dport "$1" -j ACCEPT 2>/dev/null || sudo iptables -w -I INPUT -p tcp --dport "$1" -j ACCEPT
}
