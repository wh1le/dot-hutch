{
  config,
  lib,
  pkgs,
  modulesPath,
  hostname,
  ...
}:

{
  system.stateVersion = "25.05";

  nixpkgs = {
    hostPlatform = lib.mkDefault "x86_64-linux";
    config.allowUnfree = true;
  };

  networking.hostName = "${hostname}";

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/44b4a5fa-e13f-4a1c-a7d1-a5499a0803a2";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/FE6B-635E";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };

  boot.loader.grub.extraEntries = ''
    menuentry "Windows Boot Manager" {
      search --no-floppy --fs-uuid --set=esp FE6B-635E
        chainloader ($esp)/EFI/Microsoft/Boot/bootmgfw.efi
    }
  '';

  nix.settings = {
    max-jobs = "auto";
    cores = 8;
  };

  swapDevices = [ { device = "/dev/disk/by-uuid/9572a97b-f3aa-408d-aad5-bdcaeb019c91"; } ];

  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.eno1.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp0s20f3.useDHCP = lib.mkDefault true;

  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ../modules/nzxt_kraken.nix
    ../modules/bluetooth.nix
    ../modules/browser.nix
    ../modules/desktop.nix
    ../modules/fonts.nix
    ../modules/images.nix
    ../modules/languages.nix
    # ../modules/mime_types.nix
    ../modules/network.nix
    ../modules/nvidia.nix
    ../modules/nvim.nix
    ../modules/paperlike.nix
    ../modules/security.nix
    ../modules/audio.nix
    ../modules/terminal.nix
    ../modules/users.nix
    ../modules/vpn.nix
    ../modules/hyprland.nix
    ../modules/icons.nix
    ../modules/xserver.nix
    ../modules/filesystem.nix
    ../modules/video.nix
    ../modules/game.nix
    ../modules/boot.nix
  ];
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  environment.systemPackages = with pkgs; [
    usbutils
    libinput
    socat

    # TODO: move
    expressvpn
    veracrypt
    mpv

    grimblast
    imgcat
    desktop-file-utils
    lm_sensors
  ];
}
