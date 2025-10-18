{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    usbutils
    libinput
    # socat
  ];
}
