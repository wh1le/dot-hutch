{
  pkgs,
  ...
}:
{

  environment.systemPackages = with pkgs; [
    gparted
    efibootmgr
    hfsprogs
    ncdu # freespace
    file
    bzip2
    unzip
  ];
}
