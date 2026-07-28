#!/usr/bin/env bash
socat -U - UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock | while read -r line; do
  case $line in
    activewindow\>\>firefox,*)
      hyprctl --batch -q "\
        keyword unbind CTRL,J;\
        keyword unbind CTRL,K;\
        keyword unbind CTRL,H;\
        keyword unbind CTRL,L;\
        keyword bind CTRL,J,exec,ydotool key 29:1 15:1 15:0 29:0;\
        keyword bind CTRL,K,exec,ydotool key 29:1 42:1 15:1 15:0 42:0 29:0;\
        keyword bind CTRL,H,exec,ydotool key 56:1 105:1 105:0 56:0;\
        keyword bind CTRL,L,exec,ydotool key 56:1 106:1 106:0 56:0"
      ;;
    activewindow\>\>*)
      hyprctl --batch -q "\
        keyword unbind CTRL,J;\
        keyword unbind CTRL,K;\
        keyword unbind CTRL,H;\
        keyword unbind CTRL,L"
      ;;
  esac
done
