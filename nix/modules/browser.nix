{
  pkgs,
}:
{
  environment.variables = {
    BROWSER = "firefox";
  };

  # TODO: Configure pywallfox
  # system.activationScripts.pywalfox = {
  #   text = ''
  #     runuser -l wh1le -c '${pkgs.pywalfox-native}/bin/pywalfox install || true
  #   '';
  # };

  environment.sessionVariables.DEFAULT_BROWSER = "${pkgs.firefox}/bin/firefox";

  environment.systemPackages = with pkgs; [
    firefox
    ungoogled-chromium
  ];
}
