function system-wm-reload() {
  xrdb -merge ~/.Xresources
  if [ "$(hostname)" = homepc ]; then
    autorandr --change --default vnc --force 2>/dev/null && return
  else
    autorandr --change --force 2>/dev/null && return
  fi
  i3-msg restart
}

function system-screen-share-start() {
  local viewport="$HOME/.local/bin/public/x11/vnc-viewport"
  setopt localtraps
  trap "$viewport off" INT TERM
  x11vnc -display :0 -noxdamage -forever -shared -rfbport 5900 \
    -scale 1 -scale_cursor 1 -repeat -capslock -nomodtweak \
    -afteraccept "$viewport on" -gone "$viewport off"
  "$viewport" off
}

function system-screen-share-connect() {
  vncviewer -FullScreen -FullscreenSystemKeys=1 $1
}
