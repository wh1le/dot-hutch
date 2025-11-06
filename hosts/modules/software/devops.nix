{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.busybox
    pkgs.pciutils

    pkgs.systemctl-tui
    pkgs.sysz

    pkgs.lazyjournal
  ];
}
