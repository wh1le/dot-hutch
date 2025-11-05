{
  pkgs,
  ...
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

  environment.sessionVariables.DEFAULT_BROWSER = "${pkgs.firefox}/bin/firefox";

  environment.systemPackages = with pkgs; [
    firefox
    # nativefier
  ];
}
