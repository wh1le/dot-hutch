{
  pkgs,
  ...
}:
{

  environment.systemPackages = with pkgs; [
    gparted
    # xorg.xhost

    hfsprogs

    file
    bzip2
    unzip
    efibootmgr
  ];
}
