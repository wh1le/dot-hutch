{ pkgs
, unstable
, ...
}:
{
  environment.variables = {
    BROWSER = "qutebrowser";
  };

  programs.firefox = {
    enable = true;

    preferences = {
      "browser.sessionstore.restore_on_demand" = true;
      "browser.sessionstore.restore_pinned_tabs_on_demand" = true;
      "browser.tabs.min_inactive_duration_before_unload" = 600000;
    };
  };

  environment.sessionVariables.DEFAULT_BROWSER = "${unstable.qutebrowser}/bin/qutebrowser";

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

    # unstable.tridactyl-native
    unstable.firefox

    unstable.qutebrowser
  ];
}
