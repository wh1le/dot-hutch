{ ... }: {
  services.greetd.enable = true;

  systemd.services.greetd.serviceConfig = {
    Type = "idle";
    StandardOutput = "tty";
  };
}
