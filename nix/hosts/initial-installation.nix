{ pkgs, self, ... }:

let
  mainUser = "wh1le";
  dotFilesFlagPath = "/home/${mainUser}/.config/";
  dotFilesFlagFilePath = "${dotFilesFlagPath}/.deployed";
in 
{
  # --- Basic System Setup ---
  system.stateVersion = "25.05";
  networking.hostName = "wh1le-vm-debug";
  networking.networkmanager.enable = true;
  time.timeZone = "Europe/Lisbon";
  i18n.defaultLocale = "en_US.UTF-8";

  # --- User Account ---
users.users.${mainUser} = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" "audio" "video" "input" "tss" ];
    initialPassword = "1234";
    shell = pkgs.zsh;
  };

  security.sudo.enable = true;
  security.sudo.wheelNeedsPassword = false;

  fonts.packages = with pkgs; [
    atkinson-hyperlegible
    jetbrains-mono
    noto-fonts-color-emoji
  ];

  services.xserver = {
      xkb = {
        layout = "us,ru";
        options = "grp:ctrl_space_toggle,ctrl:swapcaps";
      };
  };

  hardware.opengl = {
    enable = true;
  };

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

	xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  };

  services.displayManager.ly.enable = true;
  programs.zsh.enable = true;

  # --- VM & SSH Essentials ---
  services.qemuGuest.enable = true;
  services.openssh.enable = true;

  virtualisation = {
    memorySize = 16384;

    cores = 6;
    qemu.options = [ "-device virtio-gpu-pci" ];
  };


  # --- A few essential packages ---
  environment.systemPackages = with pkgs; [
    # Terminal
    bash
    zsh
    fzf
    tmux
    vim
    neovim
    btop
    htop

    git

    kitty
    wezterm

    # Encryption
    veracrypt
    openssl

    # GUI/TUI
		wofi
    firefox

		kdePackages.dolphin
    zoom-us

    nerd-font-patcher

    # UI
    pywal16
    
    # Ruby
    openssl libyaml zlib readline autoconf bison pkg-config

    # Lua
    lua lua54Packages.nlua

    # C and make
    gnumake pkg-config cmake clang libgcc

    # Perl
    perl

		# Python
		python3 python313Packages.pynvim
  ];

  systemd.services.dotfiles-setup = {
    description = "Dotfiles bootstrap";
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    unitConfig.ConditionPathExists = "!${dotFilesFlagFilePath}";
    serviceConfig = {
      Type = "oneshot";
      User = "${mainUser}";
      WorkingDirectory = "/home/${mainUser}";
    };
    script = ''
      set -euo pipefail
      export PATH=${pkgs.lib.makeBinPath [ pkgs.git pkgs.gnumake pkgs.coreutils pkgs.util-linux pkgs.bash pkgs.python3 ]}
      mkdir -p -- "${dotFilesFlagPath}"
      ${pkgs.bash}/bin/bash ${../../scripts/deploy-dotfiles.sh} ${mainUser}
      touch "${dotFilesFlagPath}"
    '';
  };
}