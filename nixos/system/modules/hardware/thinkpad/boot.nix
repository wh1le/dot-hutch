{ pkgs, lib, config, ... }:
let
  hasKeys = builtins.pathExists /var/lib/sbctl/keys/db/db.key;
in
{
  # amd_pstate version logic lives in boot-amd.nix (merged across modules)
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.plymouth =
    let
      recolored = ../../../../../assets/plymouth/hexagon_dots_alt/recolored;
      original = ../../../../../assets/plymouth/hexagon_dots_alt/original;
    in
    {
      enable = true;
      theme = "hexagon_dots_alt";
      themePackages = [
        (pkgs.runCommand "plymouth-hexagon-dots-alt" { } ''
          dir=$out/share/plymouth/themes/hexagon_dots_alt
          mkdir -p $dir
          cp ${recolored}/*.png $dir/
          cp ${original}/hexagon_dots_alt.script $dir/
          substitute ${original}/hexagon_dots_alt.plymouth $dir/hexagon_dots_alt.plymouth \
            --replace "/usr/share/plymouth/themes" "$out/share/plymouth/themes"
        '')
      ];
    };

  # Silent boot — hides log noise so Plymouth runs uninterrupted
  # https://wiki.nixos.org/wiki/Plymouth
  boot.consoleLogLevel = 3;
  boot.initrd.verbose = false;

  boot.kernelParams = [
    "apm=power_off"
    "pcie_aspm=force" # Helps AMD power saving
    "quiet"
    "udev.log_level=3"
    "systemd.show_status=auto"
  ];

  boot.kernel.sysctl = {
    "kernel.perf_event_paranoid" = -1; # Unlock the kernel stats for powertop 
  };

  boot.kernelModules = [
    "hid_apple"
    "kvm-amd"
    "btusb"
    "thinkpad_acpi"
  ];

  boot.extraModulePackages = [ ];

  boot.extraModprobeConfig = ''
    options hid_apple iso_layout=0 fnmode=2
    options thinkpad_acpi fan_control=1
  '';

  boot.initrd = {
    systemd.enable = true;
    kernelModules = [ "amdgpu" ];
    availableKernelModules = [
      "xhci_pci"
      "nvme"
      "usb_storage"
      "usbhid"
      "sd_mod"
      "thunderbolt"

      "tpm_tis"
      "tpm_crb"
    ];
  };

  boot.loader = {
    systemd-boot = {
      # enable = false;
      configurationLimit = 10;
    };
    timeout = 1;
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
  };

  boot.lanzaboote = {
    enable = hasKeys;
    pkiBundle = "/var/lib/sbctl";
  };

  boot.loader.systemd-boot.enable = !config.boot.lanzaboote.enable;

  warnings = lib.optional (!hasKeys) "Secure Boot disabled: sbctl keys not found at /var/lib/sbctl/keys/db/db.key enable after installation or delete";

  # boot.lanzaboote = {
  #   enable = true;
  #   pkiBundle = "/var/lib/sbctl";
  # };

  hardware.enableRedistributableFirmware = true;
  hardware.cpu.amd.updateMicrocode = true;

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  environment.systemPackages = [
    pkgs.sbctl # boot keys generation
  ];
}
