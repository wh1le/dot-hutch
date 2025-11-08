source $HOME/.config/zsh/aliases/veracrypt
source $HOME/.config/zsh/aliases/media
source $HOME/.config/zsh/aliases/nix
source $HOME/.config/zsh/aliases/ops
source $HOME/.config/zsh/aliases/youtube

# vimlike
alias :e=nvim
alias :sp='test -n "$TMUX" && tmux split-window'
alias :vs='test -n "$TMUX" && tmux split-window -h'
alias :qa=exit
alias :wq=exit

# Ruby
alias b=bundle
alias be='bundle exec'

# Git
alias g=git
alias gl="git log --oneline"
alias gs='git status'
alias gc='git checkout'
alias gr='git rebase -i'
alias gd='helper-git-diff'
alias gh='helper-git-history'

alias python-watch="helper-python-watch"

# Tmux
alias ta="tmux attach"

# Edit configs

alias ezsh="cd ~/.config/zsh && nvim ."
alias ehypr="cd ~/.config/hypr && nvim ."
alias ekanshi="cd ~/.config/kanshi && nvim ."
alias envim="cd ~/.config/nvim && nvim ."
alias etmux="cd ~/.config/etmux && nvim ."
alias enixpub="cd ~/dot/nix-public && nvim ."
alias enixpri="cd ~/dot/nix-private && nvim ."

alias vim="nvim"
alias freespace="ncdu -x"
alias open="xdg-open"

function show-font-styles() {
  # "JetBrainsMono Nerd Font Mono"
  fc-list $1 -f '%{style}\n' | sed 's/,/\n/g' | sort -u
}

alias slogs="sudo journalctl -u"
alias status="sudo systemctl status"

alias copy="rsync -ah --info=progress2 --stats"

alias dmenu_run="dmenu-wl_run"
