{ pkgs, ... }:
{
  services.gvfs.enable = true;
  services.udisks2.enable = true;

  environment.etc."udisks2/mount_options.conf".text = ''
    [defaults]
    # prefer kernel ntfs3 and set owner + umask
    ntfs:ntfs3_defaults=uid=$UID,gid=$GID,umask=022
    ntfs_drivers=ntfs3,ntfs

    # FAT/exFAT ownership + sane masks
    vfat_defaults=uid=$UID,gid=$GID,umask=022,shortname=mixed
    exfat_defaults=uid=$UID,gid=$GID,umask=022
  '';

  environment.systemPackages = with pkgs; [
    usbutils
    libinput
    # socat

    exfatprogs
    dosfstools
    ntfs3g
  ];
}
