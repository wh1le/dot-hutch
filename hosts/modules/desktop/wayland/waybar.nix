{ pkgs, unstable, config, ... }: {

  sops.secrets.openweathermap = {
    owner = config.users.users.wh1le.name;
    group = "users";
    mode = "0400";
  };

  environment.systemPackages = [
    unstable.waybar
    pkgs.inotify-tools # livereload on waybar config edit
  ];
}
