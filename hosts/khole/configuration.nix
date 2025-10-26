{
  modulesPath,
  config,
  pkgs,
  lib,
  ...
}:

let
  WLAN_SSID = "1234";
  WLAN_PASSWORD = "1234";
in
{
  networking.hostName = "khole";
  system.stateVersion = "25.05";

  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ./hardware-configuration.nix
    ./image.nix

    ../modules/security/firewall.nix

    ../modules/system/users.nix
    ../modules/system/fonts.nix

    ../modules/software/virtualisation.nix
    ../modules/software/containers/pi-hole.nix
  ];

  networking.firewall.allowedTCPPorts = [
    1234
    80
    53
  ];

  networking.firewall.allowedUDPPorts = [
    53
    67
  ];

  hardware.nvidia-container-toolkit.suppressNvidiaDriverAssertion = config.boot.isContainer;
  services.desktopManager.plasma6.enable = true;

  environment.systemPackages = with pkgs; [
    neovim
    kitty
    htop
    nano
    nmap
    nettools
    iputils
    unzip
    usbutils
  ];

  users = {
    mutableUsers = true;

    users.wh1le = {
      isNormalUser = true;
      initialPassword = "hackme";
      extraGroups = [
        "wheel"
        "docker"
      ];
      # openssh.authorizedKeys.keys = [ USER_SSH_PUBLIC_KEY ];
    };
  };

  /*
    SSH
    - disable password authentication
    - ed25519 keys only
    - non-default 22 port
  */
  services.openssh = {
    enable = true;
    ports = [ 1234 ];

    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = lib.mkForce "no";
      KexAlgorithms = [
        # ssh-ed25519
        "curve25519-sha256"
        "curve25519-sha256@libssh.org"
      ];
    };
  };

  /*
    Networking (for wlan0 interface, no NetworkManager)
    - disable DHCP
    - use static IP
    - use default gateway
    - restricted firewall
    - initial wireless connection
  */

  networking = {
    useDHCP = lib.mkForce false;

    nameservers = [ "192.168.1.1" ];
    defaultGateway = {
      address = "192.168.1.1";
      interface = "wlan0";
    };

    interfaces = {
      "wlan0" = {
        useDHCP = lib.mkForce false;

        ipv4.addresses = [
          {
            address = "192.168.1.123";
            prefixLength = 24;
          }
        ];
      };
    };

    # wireless = {
    #   enable = true;
    #
    #   networks."${WLAN_SSID}" = {
    #     psk = "${WLAN_PASSWORD}";
    #   };
    # };
  };
}
