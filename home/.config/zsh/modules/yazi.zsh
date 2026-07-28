function y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
  local -a term_env

  [[ -n $TMUX && -n $KITTY_WINDOW_ID ]] && term_env=(TERM=xterm-kitty)

  env $term_env yazi "$@" --cwd-file="$tmp"

  if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    cd -- "$cwd"
  fi

  rm -f -- "$tmp"
}
