{ pkgs, ... }:
{
  programs.virt-manager.enable = true;

  services.spice-vdagentd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;

  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
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
