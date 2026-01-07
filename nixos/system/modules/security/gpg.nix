{ pkgs, unstable, ... }: {
  systemd.tmpfiles.rules = [
    "d /home/wh1le/.gnupg 0700 wh1le users -"
  ];

  programs.gnupg.agent = {
    enable = true;
    # pinentryPackage = pkgs.pinentry-qt;
    pinentryPackage = pkgs.pinentry-gnome3;
  };

  environment.systemPackages = [
    unstable.pinentry-curses # pinentry
  ];
}
