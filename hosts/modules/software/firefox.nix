{ pkgs
, unstable
, ...
}:
{
  environment.variables = {
    BROWSER = "firefox";
  };

  # TODO: Configure pywallfox
  # system.activationScripts.pywalfox = {
  #   text = ''
  #     runuser -l ${settings.mainUser} -c '${pkgs.pywalfox-native}/bin/pywalfox update || true
  #   '';
  # };

  environment.sessionVariables.DEFAULT_BROWSER = "${unstable.firefox}/bin/firefox";

  environment.systemPackages = [
    (pkgs.makeDesktopItem {
      name = "Firefox (Work Profile)";
      desktopName = "Firefox (Work Profile)";
      comment = "Firefox";
      exec = "firefox -p work";
      icon = "firefox";
      categories = [
        "Network"
        "WebBrowser"
      ];
    })

    unstable.firefox
  ];
}
