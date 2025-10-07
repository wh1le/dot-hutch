{
  config,
  pkgs,
  lib,
  ...
}:

let
  mainUser = "wh1le";
  dotFilesFlagPath = "/home/${mainUser}/.config/";
  dotFilesFlagFilePath = "${dotFilesFlagPath}/deployed";
in
{
  imports = [
    ./hardware-configuration.nix
    ../network.nix
    ../nvim.nix
  ];

  # TODO: Configure pywallfox
  # system.activationScripts.pywalfox = {
  #   text = ''
  #     runuser -l wh1le -c '${pkgs.pywalfox-native}/bin/pywalfox install || true
  #   '';
  # };

  nixpkgs = {
    hostPlatform = lib.mkDefault "x86_64-linux";
    config.allowUnfree = true;
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  boot = {
    initrd = {
      availableKernelModules = [
        "vmd"
        "xhci_pci"
        "ahci"
        "nvme"
        "usb_storage"
        "usbhid"
        "sd_mod"
      ];
      kernelModules = [ ];
    };

    loader = {
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        useOSProber = true;
        copyKernels = false;
        configurationLimit = 5;
      };
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
    };

    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];
  };

  system.stateVersion = "25.05";

  users.users.wh1le = {
    isNormalUser = true;
    extraGroups = [
      "networkmanager"
      "wheel"
      "audio"
      "video"
      "input"
      "tss"
    ];
    shell = pkgs.zsh;
  };

  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };

    printers = {
      ensurePrinters = [
        {
          name = "EPSON_XP_2200";
          location = "Home";
          # Prefer IPP. Use hostname if it resolves, else the IP.
          deviceUri = "ipp://EPSON.local/ipp/print"; # or: ipp://192.168.178.X/ipp/print
          model = "everywhere"; # driverless
          ppdOptions = {
            PageSize = "A4";
            ColorModel = "Gray";
          };
        }
      ];
      ensureDefaultPrinter = "EPSON_XP_2200";
    };

    nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      open = true;
      modesetting.enable = true;
    };
  };

  time.timeZone = "Europe/Lisbon";
  i18n.defaultLocale = "en_US.UTF-8";

  security = {
    sudo.enable = true;
    sudo.wheelNeedsPassword = false;
  };

  fonts = {
    packages = with pkgs; [
      atkinson-hyperlegible
      nerd-fonts.jetbrains-mono
      nerd-fonts.atkynson-mono
      noto-fonts-color-emoji
      noto-fonts-emoji
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = [ "Atkinson Hyperlegible" ];
        sansSerif = [ "Atkinson Hyperlegible" ];
        monospace = [
          "Atkinson Hyperlegible Mono"
          "JetBrainsMono Nerd Font"
        ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };

  services = {
    xserver = {
      xkb = {
        layout = "us,ru";
        options = "grp:ctrl_space_toggle,ctrl:swapcaps";
      };
      # xkbOptions=
      videoDrivers = [ "nvidia" ];

    };

    printing = {
      enable = true;
      # drivers = [ pkgs.hplipWithPlugin ];
    };

    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    sunshine = {
      enable = true;
      autoStart = true;
      capSysAdmin = true; # wayland specific
      openFirewall = true;
    };

    displayManager.ly.enable = true;

    resolved.enable = true;
    expressvpn.enable = true;
    openssh.enable = true;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # jack.enable = true; # Uncomment the following line if you want to use JACK applications
    };
  };

  # users.groups.keyd = {};
  # services.keyd = { enable = true; };

  programs = {
    steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
      localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
    };
    ssh = {
      startAgent = true;
      agentTimeout = "1h";
    };

    hyprland = {
      enable = true;
      xwayland.enable = true;
    };

    zsh.enable = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  };

  systemd = {
    services = {
      dunst = {
        enable = true;
      };

      # printing.ensurePrinters = false;
      #
      # Fix me or move to home manager
      dotfiles-setup = {
        description = "Dotfiles bootstrap";
        wantedBy = [ "multi-user.target" ];
        wants = [ "network-online.target" ];
        after = [
          "network-online.target"
          "NetworkManager-wait-online.service"
        ];

        unitConfig.ConditionPathExists = "!${dotFilesFlagFilePath}";
        # serviceConfig = {
        #  Type = "oneshot";
        #  User = "${mainUser}";
        #  WorkingDirectory = "/home/${mainUser}";
        #};

        serviceConfig = {
          Type = "oneshot";
          User = "wh1le";
          WorkingDirectory = "/home/wh1le/dot";
          PrivateNetwork = false;
          ProtectSystem = "strict";
          ProtectHome = "read-only";
          ReadWritePaths = [
            "/home/${mainUser}/dot"
            "/tmp"
          ];
        };

        script = ''
          set -euo pipefail
          export PATH=${
            pkgs.lib.makeBinPath [
              pkgs.git
              pkgs.gnumake
              pkgs.coreutils
              pkgs.util-linux
              pkgs.bash
              pkgs.python3
            ]
          }
          mkdir -p -- "${dotFilesFlagPath}"
          ${pkgs.bash}/bin/bash ${../../scripts/deploy-dotfiles.sh} ${mainUser}
        '';
      };
    };
  };

  environment.systemPackages = with pkgs; [
    # --- C and make --- #
    gnumake
    pkg-config
    cmake
    clang
    libgcc
    # --- C and make --- #

    # --- system languages support   --- #
    mercurial
    nodejs_24
    perl
    ruby_3_4
    # --- languages support   --- #

    # --- terminal --- #
    bash
    zsh
    tree
    fzf
    tmux
    vim

    btop
    htop
    kitty
    direnv
    nix-direnv
    yazi
    # of
    buku
    xh
    tldr
    bat
    nsxiv
    # http # api
    # kulala.nvim
    # https://github.com/kawre/leetcode.nvim
    # posting
    # lazygit
    # -- terminal --- #

    # --- System utils --- #
    manix
    nix-search-tv
    bluetui
    bluez
    usbutils
    libinput
    inotify-tools # livereload
    git
    dunst
    libnotify
    jq
    imagemagick
    wl-clipboard
    grim
    slurp
    wf-recorder
    nerd-font-patcher
    pavucontrol
    ncdu
    silver-searcher
    mutt
    paperlike-go # Dasung
    # --- System utils --- #
    # dooit

    # --- Wine --- #
    wineWowPackages.stable # support both 32-bit and 64-bit applications
    (wine.override { wineBuild = "wine64"; }) # support 64-bit only
    wine64 # support 64-bit only
    wineWowPackages.staging # wine-staging (version with experimental features)
    winetricks # winetricks (all versions)
    wineWowPackages.waylandFull # native wayland support (unstable)
    # --- Wine --- #

    # --- VPN --- #
    expressvpn
    openvpn
    # --- VPN --- #

    # --- Security & encryption --- #
    veracrypt
    openssl
    # --- Security & encryption --- #

    # --- GDK, QT apps --- #
    telegram-desktop
    ungoogled-chromium
    firefox
    vlc
    thunderbird
    obsidian
    gimp
    xfce.thunar
    zoom-us
    # --- GDK, QT apps --- #

    # --- UI, window manager utils --- #
    gtk3
    gtk4
    wofi
    fastfetch
    pywal16
    pywalfox-native
    swaybg
    waybar
    swww
    # --- UI, window manager utils --- #
  ];
}
