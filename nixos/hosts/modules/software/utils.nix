{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    lm_sensors
    kanshi
  ];

  # services.kanshi = {
  #   enable = true;
  #   systemdTarget = "hyprland-session.target";
  # };
}
