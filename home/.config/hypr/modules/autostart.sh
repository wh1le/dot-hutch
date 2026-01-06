#!/usr/bin/env bash

logs_dir="$HOME/.cache/startup"
log_file="$logs_dir/autostart.log"

exec &> >(while read -r line; do echo "[$(date '+%H:%M:%S')] $line"; done >>"$log_file")

# log() {
#   local name="$1"
#   shift
#   "$@" 2>&1 | sed "s/^/[$name] /" >>"$log_file" &
# }

log() {
  local name="$1"
  shift
  "$@" 2>&1 | while read -r line; do
    flock "$log_file" -c "echo '[$name] $line' >> '$log_file'"
  done &
}

# log() {
#   echo "[$(date '+%H:%M:%S')] [$1] $2" >>"$log_file"
# }

is_laptop() {
  [[ "$(hostname)" =~ ^(thinkpad|laptop_work)$ ]]
}

launch_hyprland() {
  hyprctl dispatch exec "[workspace $1 silent] uwsm app -- $2" &>/dev/null
}

eink_connected() {
  $HOME/.local/bin/public/eink/paperlike-connected
}

mkdir -p "$logs_dir"

{
  echo ""
  echo "========================================"
  echo "NEW SESSION: $(date '+%Y-%m-%d %H:%M:%S')"
  echo "Host: $(hostname)"
  echo "User: $USER"
  echo "WAYLAND_DISPLAY: $WAYLAND_DISPLAY"
  echo "========================================"
} >>"$log_file"

CONFIGURATION_PATH="$HOME/dot/nix-public"

# First boot
if [ -d CONFIGURATION_PATH ]; then
  if [ ! -f $HOME/.current_wallpaper ]; then
    ln -sfn $CONFIGURATION_PATH/assets/wallpapers/forest.jpg $HOME/.current_wallpaper
  fi

  if [ ! -d ~/.cache/wal ]; then
    wal -esnti $HOME/.current_wallpaper
  fi
fi

# log uwsm app -- dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP HYPRLAND_INSTANCE_SIGNATURE
# log uwsm app -- systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP HYPRLAND_INSTANCE_SIGNATURE
# log uwsm app -- /run/current-system/sw/libexec/polkit-kde-authentication-agent-1
# uwsm app -- gpg-connect-agent updatestartuptty /bye
log hyprpolkitagent uwsm app -- systemctl --user start hyprpolkitagent &
log swaync uwsm app -- swaync & # TODO: add config

# Block until swaync registers on D-Bus
while ! busctl --user status org.freedesktop.Notifications &>/dev/null; do
  sleep 0.1
done

log kanshi uwsm app -- kanshi &
log waybar uwsm app -- waybar -c "$HOME/.config/waybar/hosts/$(hostname).jsonc" &
log hyprsunset uwsm app -- hyprsunset &
log hypridle uwsm app -- hypridle -c $HOME/.config/hypr/hypridle/hypridle-$(hostname).conf &
log swww-daemon uwsm app -- swww-daemon &
log wl-paste uwsm app -- wl-paste --watch cliphist store &

log kbuildsycoca6 uwsm app -- kbuildsycoca6 &

pgrep -x mpd-mpris || log mpd-mpris uwsm app -- mpd-mpris &

log pass-git-push-daemon uwsm app -- $HOME/.local/bin/public/pass/git-watcher-push &
log einkify-daemon uwsm app -- $HOME/.config/hypr/scripts/daemons/einkify &
# log uwsm app -- $HOME/.local/bin/public/qutebrowser-sync --remote ~/Cloud/disroot # write daemon

log wallpaper-on-boot $HOME/.local/bin/public/wallpaper/set-on-boot &
log dark-mode uwsm app -- $HOME/.local/bin/public/color-mode/dark-mode skip-notification &

if is_laptop; then
  log power-manager uwsm app -- $HOME/.local/bin/public/sound/audio-profile-power-monitor &
  log battery-daemon uwsm app -- $HOME/.local/bin/public/battery-status &
  # uwsm app -- libinput-gestures
fi

if [[ "$(hostname)" == "thinkpad" ]]; then
  log thinkpad-settings $HOME/.config/hypr/scripts/set-thinkpad-settings
fi

if [[ "$(hostname)" == "homepc" ]]; then
  log homepc-settings $HOME/.config/hypr/scripts/set-homepc-settings &
fi

launch_hyprland 1 "qutebrowser" &
launch_hyprland 2 "$HOME/.local/bin/public/applications/kitty-eink --class main zsh -lic 'tmux attach-session -t local; exec zsh'" &
launch_hyprland 3 "obsidian" &
launch_hyprland 4 "kitty zsh -lic 'rmpc; exec zsh -i'" &

wait
