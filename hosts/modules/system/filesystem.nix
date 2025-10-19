{
  pkgs,
  ...
}:
{

  services.udisks2.enable = true;
  security.polkit.enable = true;
  programs.xwayland.enable = true;

  environment.systemPackages = with pkgs; [
    # TODO: try to install later
    # pkgs.kdePackages.partitionmanager
    gparted
    kdePackages.polkit-kde-agent-1 # or: lxqt.lxqt-policykit
    xorg.xhost

    file

    bzip2
    unzip
    udisks
    efibootmgr
  ];
}
