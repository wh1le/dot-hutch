open() {
  emulate -L zsh
  setopt localoptions nomonitor # no job table → no [n] pid / done lines

  _focus_dolphin() {
    hyprctl dispatch focuswindow class:org.kde.dolphin >/dev/null 2>&1 || hyprctl dispatch focuswindow class:dolphin >/dev/null 2>&1
  }

  if [ "$#" -eq 0 ]; then # no args → current dir as folder
    dolphin . >/dev/null 2>&1 &
    sleep 0.1
    _focus_dolphin
    return
  fi

  if [ "$#" -eq 1 ] && [ -d "$1" ]; then
    dolphin "$1" >/dev/null 2>&1 &
    sleep 0.1
    _focus_dolphin
    return
  fi

  command xdg-open "$@" >/dev/null 2>&1
}
