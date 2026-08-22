open() {
  emulate -L zsh
  setopt localoptions nomonitor # no job table → no [n] pid / done lines

  if [[ "$OSTYPE" == darwin* ]]; then
    if [ "$#" -eq 0 ]; then
      command open .
    else
      command open "$@"
    fi
    return
  fi

  _focus_nautilus() {
    hyprctl dispatch focuswindow class:nautilus >/dev/null 2>&1 || hyprctl dispatch focuswindow class:org.gnome.Nautilus >/dev/null 2>&1
  }

  if [ "$#" -eq 0 ]; then # no args → current dir as folder
    nautilus . >/dev/null 2>&1 &
    sleep 0.1
    _focus_nautilus
    return
  fi

  if [ "$#" -eq 1 ] && [ -d "$1" ]; then
    nautilus "$1" >/dev/null 2>&1 &
    sleep 0.1
    _focus_nautilus
    return
  fi

  command xdg-open "$@" >/dev/null 2>&1
}
