{
  modulesPath,
  config,
  pkgs,
  ...
}:
{
  networking.hostName = "khole";
  system.stateVersion = "25.05";

  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ./hardware-configuration.nix

    ../modules/security/firewall.nix

    ../modules/system/users.nix
    ../modules/system/fonts.nix

    ../modules/software/virtualisation.nix
    ../modules/software/containers/pi-hole.nix
  ];

  services.openssh.enable = true;
  networking.firewall.allowedTCPPorts = [ 22 ];

  hardware.nvidia-container-toolkit.suppressNvidiaDriverAssertion = config.boot.isContainer;
  services.desktopManager.plasma6.enable = true;

  environment.systemPackages = with pkgs; [
    neovim
    kitty
  ];
}
