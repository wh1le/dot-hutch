{ pkgs, ... }:
{
  users.users.wh1le.extraGroups = [
    "kvm"
  ];

  programs.virt-manager.enable = true;

  services.spice-vdagentd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      ovmf.enable = true;
      swtpm.enable = true;
    };
  };

  environment.systemPackages = with pkgs; [
    samba
    libvirt
    qemu
    OVMF
    virt-manager
    virtiofsd
  ];
}
