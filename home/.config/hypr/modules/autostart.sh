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

# uwsm app -- dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP HYPRLAND_INSTANCE_SIGNATURE
# uwsm app -- systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP HYPRLAND_INSTANCE_SIGNATURE
# uwsm app -- /run/current-system/sw/libexec/polkit-kde-authentication-agent-1
# uwsm app -- gpg-connect-agent updatestartuptty /bye
uwsm app -- systemctl --user start hyprpolkitagent &
uwsm app -- swaync -c $HOME/.config/swaync/config.json -s $HOME/.config/swaync/styles/style.css &

# Block until swaync registers on D-Bus

while ! pgrep -a swaync >/dev/null; do
  sleep 0.1
done

uwsm app -- kanshi &
uwsm app -- waybar -c "$HOME/.config/waybar/hosts/$(hostname).jsonc" &
uwsm app -- hyprsunset &
uwsm app -- hypridle -c $HOME/.config/hypr/hypridle/hypridle-$(hostname).conf &
uwsm app -- swww-daemon &
uwsm app -- wl-paste --watch cliphist store &
uwsm app -- kbuildsycoca6 &
uwsm app -- mpd-mpris &

uwsm app -- $HOME/.local/bin/public/pass/git-watcher-push &
uwsm app -- $HOME/.config/hypr/scripts/daemons/einkify &
# uwsm app -- $HOME/.local/bin/public/qutebrowser-sync --remote ~/Cloud/disroot # write daemon

uwsm app -- $HOME/.local/bin/public/wallpaper/set-on-boot &
uwsm app -- $HOME/.local/bin/public/color-mode/dark-mode skip-notification &

if is_laptop; then
  uwsm app -- $HOME/.local/bin/public/sound/audio-profile-power-monitor &
  uwsm app -- $HOME/.local/bin/public/battery-status &
  # uwsm app -- libinput-gestures
fi

[[ "$(hostname)" == "thinkpad" ]] && $HOME/.config/hypr/scripts/set-thinkpad-settings &
[[ "$(hostname)" == "homepc" ]] && $HOME/.config/hypr/scripts/set-homepc-settings &

launch_hyprland 1 "qutebrowser" &
launch_hyprland 2 "$HOME/.local/bin/public/applications/kitty-eink --class main zsh -lic 'tmux attach-session -t local; exec zsh'" &
launch_hyprland 3 "obsidian" &
launch_hyprland 4 "kitty zsh -lic 'rmpc; exec zsh -i'" &

wait
