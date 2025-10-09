# Vimlike
alias :e=vim
alias :qa=exit
alias :sp='test -n "$TMUX" && tmux split-window'
alias :vs='test -n "$TMUX" && tmux split-window -h'
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

alias fspace="ncdu -x /"

# Tmux

alias ta="tmux attach"
# TODO: Tmux kill session (alias tks)

# Nix
alias nix_test="sudo nixos-rebuild test   --flake /etc/nixos#default"
alias nix_switch="sudo nixos-rebuild switch --flake /etc/nixos#default"
alias nix_build="sudo nixos-rebuild build  --flake /etc/nixos#default"
alias nix_boot="sudo nixos-rebuild boot   --flake /etc/nixos#default"
alias nix_clean="sudo nix-collect-garbage -d"
alias nix_releases_list="sudo nixos-rebuild list-generations"
alias nix_releases_switch="sudo nixos-rebuild switch --generation"
alias nix_doc='manix "" | grep "^# " | sed "s/^# \(.*\) (.*/\1/;s/ (.*//;s/^# //" | fzf --preview="manix '\''{}'\''" | xargs manix'
alias nix_packages="nix-search-tv print | fzf --preview 'nix-search-tv preview {}' --scheme history | wl-copy"

alias vim="nvim"

# Aliased for youtube download script and video
alias song="yt-dlp -x --audio-format mp3 --embed-thumbnail"
alias video="yt-dlp"
