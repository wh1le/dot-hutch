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
  networking.hostName = "khole";
  system.stateVersion = "25.05";

  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ./hardware-configuration.nix
    ./image.nix

    ../modules/security/firewall.nix

    ../modules/system/fonts.nix
    ../modules/system/locales.nix

    ../modules/software/virtualisation.nix
    ../modules/software/containers/pi-hole.nix
  ];

  sops.secrets = {
    user_password_file = {
      sopsFile = "${self}/secrets/default.yaml";
      key = "khole/user/password";
      owner = "root";
      group = "root";
      mode = "0400";
			neededForUsers = true;
    };
    ssh_key = {
      sopsFile = "${self}/secrets/default.yaml";
      key = "khole/ssh/key";
      owner = "root";
      group = "root";
      mode = "0400";
			neededForUsers = true;
    };
  };

  environment.etc."ssh/authorized_keys.d/wh1le" = {
    source = config.sops.secrets.ssh_key.path;
    # Set permissions for sshd to read it
    mode = "0644";
    user = "root";
    group = "root";
  };


  users = {
    mutableUsers = true;

    users.wh1le = {
      initialPassword = "hackme";
      isNormalUser = true;
      extraGroups = [ "wheel" "docker" "video" "input" ];
    };
  };

  services.xserver = {
    enable = true;

    displayManager.lightdm.enable = true;
    displayManager.lightdm.autoLogin.enable = true;
    displayManager.lightdm.autoLogin.user = "wh1le";

    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        i3status
      ];
    };

    xkb = {
      layout = "us,ru";
      options = "grp:ctrl_space_toggle,ctrl:swapcaps";
    };

    videoDrivers = [ "modesetting" ];
  };

  hardware.opengl.enable = true;

  # services.displayManager.autoLogin.enable = true;
  # services.displayManager.autoLogin.user = "wh1le";
  programs.ssh.startAgent = true;

  # services.getty.autologinUser = "wh1le";

  # need this line in order to build under oc
  hardware.nvidia-container-toolkit.suppressNvidiaDriverAssertion = config.boot.isContainer;

  networking.firewall.allowedTCPPorts = [ KHOLE_SSH_PORT ];
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
    git
    tmux
    neovim
    kitty
    firefox

    htop
    nano
    nmap

    nettools
    iputils
    unzip
    usbutils
  ];
}
