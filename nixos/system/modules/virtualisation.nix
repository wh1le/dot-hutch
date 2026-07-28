{ pkgs, config, lib, ... }:
{
  systemd.user.extraConfig = ''
    DefaultEnvironment="PATH=/run/current-system/sw/bin:/run/wrappers/bin:${lib.makeBinPath [ pkgs.bash ]}"
  '';

  virtualisation = {
    docker = {
      enable = true;
      enableOnBoot = false;
      storageDriver = "overlay2";
      daemon.settings = {
        experimental = true;
        "features" = {
          "cdi" = true;
        };
      };
    };
    podman = {
      enable = true;
      defaultNetwork.settings.dns_enabled = true;
    };
    oci-containers.backend = "podman";
    spiceUSBRedirection.enable = true;
    libvirtd = {
      enable = config.networking.hostName == "homepc";
      qemu = {
        package = pkgs.qemu_kvm;
        swtpm.enable = true;
        vhostUserPackages = with pkgs; [ virtiofsd ];
      };
      # spiceUSBRedirection.enable = true;
    };
  };

  programs.virt-manager.enable = true;
  services.spice-vdagentd.enable = true;

  environment.systemPackages = with pkgs; [
    # pkgs.dive # look into docker image layers
    # pkgs.oxker
    pkgs.docker-compose
    pkgs.podman
    pkgs.podman-tui # Terminal mgmt UI for Podman
    pkgs.passt # For Pasta rootless networking
    pkgs.vagrant
    libvirt
    qemu_kvm
    virt-manager
    virt-viewer
    virtiofsd
    OVMF
    distrobox
    quickemu
    cdrtools # iso creation
    bottles
  ];
}
