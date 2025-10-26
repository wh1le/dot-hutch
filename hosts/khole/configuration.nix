{
  modulesPath,
  config,
  pkgs,
  lib,
  self,
  ...
}:
let
  KHOLE_IP = "192.168.1.253";
  KHOLE_ROUTER_IP = "192.168.1.254";
  KHOLE_SSH_PORT = 1234;
  KHOLE_UNBOUND_PORT = "5355";
in
{
  sops.secrets = {
    user_password_file = {
      sopsFile = "${self}/secrets/default.yaml";
      key = "khole.user.password";
      owner = "root";
      group = "root";
      mode = "0400";
    };
    ssh_key = {
      sopsFile = "${self}/secrets/default.yaml";
      key = "khole.ssh.key";
      owner = "root";
      group = "root";
      mode = "0400";
    };
  };

  environment.etc."ssh/authorized_keys.d/wh1le" = {
    source = config.sops.secrets.ssh_key.path;
    # Set permissions for sshd to read it
    mode = "0644";
    user = "root";
    group = "root";
  };

  networking.hostName = "khole";
  system.stateVersion = "25.05";

  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ./hardware-configuration.nix
    ./image.nix

    ../modules/security/firewall.nix

    ../modules/system/users.nix
    ../modules/system/fonts.nix
    ../modules/system/keyboard.nix
    ../modules/system/locales.nix

    ../modules/software/virtualisation.nix
    ../modules/software/containers/pi-hole.nix
  ];

  # TODO: remove if not needed
  hardware.nvidia-container-toolkit.suppressNvidiaDriverAssertion = config.boot.isContainer;

  networking.firewall.allowedTCPPorts = [
    KHOLE_SSH_PORT
  ];

  # Desktop env
  services.xserver.enable = true;
  services.xserver.desktopManager.lxqt.enable = true;
  services.displayManager.sddm.enable = true;

  users = {
    mutableUsers = true;

    users.wh1le = {
      isNormalUser = true;
      hashedPasswordFile = config.sops.secrets.user_password_file.path;
      extraGroups = [
        "wheel"
        "docker"
      ];
    };
  };

  services.openssh = {
    enable = true;
    ports = [
      KHOLE_SSH_PORT
    ];

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

  services.unbound = {
    enable = true;
    settings = {
      # Listen on localhost (for the Pi itself) AND its static IP
      interface = [
        "127.0.0.1"
        KHOLE_IP
      ];

      port = KHOLE_UNBOUND_PORT;

      # Allow queries from localhost and your whole home network (This will include the container)
      "access-control" = [
        { name = "127.0.0.1/32"; action = "allow"; }
        { name = "192.168.1.0/24"; action = "allow"; }
      ];
    };
  };

  networking = {
    wireless.enable = false;

    useDHCP = lib.mkForce false;

    # Use unbound to resolve DNS
    nameservers = [ "127.0.0.1" ];

    defaultGateway = {
      address = KHOLE_ROUTER_IP;
      interface = "eth0";
    };

    interfaces = {
      "eth0" = {
        useDHCP = lib.mkForce false;

        ipv4.addresses = [
          {
            address = KHOLE_IP;
            prefixLength = 24;
          }
        ];
      };
    };
  };

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
}
