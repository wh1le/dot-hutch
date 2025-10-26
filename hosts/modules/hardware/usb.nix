{ pkgs, ... }:
{
  services.gvfs.enable = true;
  services.udisks2.enable = true;

  environment.systemPackages = with pkgs; [
    usbutils
    libinput
    # socat

    exfatprogs
    dosfstools
    ntfs3g
  ];
}
