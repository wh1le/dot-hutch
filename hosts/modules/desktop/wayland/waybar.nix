{ pkgs, unstable, ... }: {
  environment.systemPackages = [
    unstable.waybar
    pkgs.inotify-tools # livereload on waybar config edit
  ];
}
