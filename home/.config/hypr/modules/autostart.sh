#!/usr/bin/env bash

is_laptop() {
  [[ "$(hostname)" =~ ^(thinkpad|laptop_work)$ ]]
}

launch_hyprland() {
  hyprctl dispatch exec "[workspace $1 silent] uwsm app -- $2" &>/dev/null
}

eink_connected() {
  $HOME/.local/bin/public/eink/paperlike-connected
}

systemctl --user start hyprpolkitagent &
uwsm app -- swaync -c "$HOME/.config/swaync/config.json" -s "$HOME/.config/swaync/styles/style.css" &

# Block until swaync registers on D-Bus

while ! pgrep -a swaync >/dev/null; do
  sleep 0.1
done

uwsm app -- kanshi &
uwsm app -- $HOME/.config/quickshell/live-reload &
uwsm app -- hyprsunset &
uwsm app -- hypridle -c $HOME/.config/hypr/hypridle/hypridle-$(hostname).conf &
uwsm app -- awww-daemon &
uwsm app -- wl-paste --type text --watch cliphist store &
uwsm app -- wl-paste --type image --watch cliphist store &
uwsm app -- wl-clip-persist --clipboard regular &
uwsm app -- mpd-mpris -no-instance &
uwsm app -- ydotoold &
uwsm app -- gnome-keyring-daemon --start --components=secrets & # flatpak services
keyd-application-mapper -d &
(sleep 10 && uwsm app -- $HOME/.config/imapfilter/setup.sh) &

uwsm app -- $HOME/.config/hypr/scripts/daemons/einkify &
uwsm app -- $HOME/.local/bin/public/wallpaper/set-on-boot &
uwsm app -- $HOME/.local/bin/public/wallpaper/apply-wallpaper

uwsm app -- $HOME/.local/bin/public/color-mode/dark-mode skip-notification &
uwsm app -- $HOME/.local/bin/public/set-folder-icons

# I kept it as a reference for something I fixed
# uwsm app -- dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP HYPRLAND_INSTANCE_SIGNATURE

if is_laptop; then
  uwsm app -- $HOME/.local/bin/public/system-audio-power-profile &
  uwsm app -- $HOME/.local/bin/public/battery-status &
  # uwsm app -- libinput-gestures
fi

[[ "$(hostname)" == "thinkpad" ]] && $HOME/.config/hypr/scripts/set-thinkpad-settings &
[[ "$(hostname)" == "homepc" ]] && $HOME/.config/hypr/scripts/set-homepc-settings &

wait
