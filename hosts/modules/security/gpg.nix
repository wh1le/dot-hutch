{ pkgs, unstable, ... }: {

  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-qt;
  };

  environment.systemPackages = [
    unstable.pinentry-curses # pinentry
  ];
}
