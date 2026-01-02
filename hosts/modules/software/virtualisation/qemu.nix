{ pkgs, config, ... }:
{
  programs.virt-manager.enable = true;

  services.spice-vdagentd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;

  virtualisation.libvirtd = {
    enable = config.networking.hostName == "homepc";
    qemu = {
      package = pkgs.qemu_kvm;
      swtpm.enable = true;
      ovmf.enable = true;
    };
  };

  # users.users.wh1le.extraGroups = [ "libvirtd" "kvm" "qemu-libvirtd" ];
  users.users.wh1le.extraGroups = [ "kvm" ];

  environment.systemPackages = with pkgs; [
    qemu_kvm
    samba
    libvirt
    qemu
    OVMF
    virt-manager
    virtiofsd
  ];
}
