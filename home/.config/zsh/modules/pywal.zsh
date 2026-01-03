_wal_update() {
  local cache=~/.cache/wal/colors-zsh.sh

  if [[ $__wal_mtime != $(stat -c %Y "$cache" 2>/dev/null) ]]; then
    source "$cache"
    __wal_mtime=$(stat -c %Y "$cache")
    source $HOME/.config/zsh/modules/prompt.zsh
  fi
}
precmd_functions+=(_wal_update)
