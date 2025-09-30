{ config, pkgs, ... }:

{
  # --- Basic System Setup ---
  system.stateVersion = "25.05";
  networking.hostName = "wh1le-vm-debug";
  networking.networkmanager.enable = true;
  time.timeZone = "Europe/Lisbon";
  i18n.defaultLocale = "en_US.UTF-8";

  # --- User Account ---
  users.users.wh1le = {
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
    bash
    zsh
    fzf

    git

    tmux
    vim
    neovim

    kitty
    wezterm

    btop
    htop

		wofi

    veracrypt

    firefox
		kdePackages.dolphin
    zoom-us

    nerd-font-patcher

    # C and make
    pkg-config gnumake cmake

		# Python
		python3 pyenv
  ];

  systemd.services.dotfiles-setup = {
    description = "Dotfiles bootstrap";
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    unitConfig.ConditionPathExists = "!/home/wh1le/.dotfiles-setup-done";
    serviceConfig = {
      Type = "oneshot";
      User = "wh1le";
      WorkingDirectory = "/home/wh1le";
    };
    script = ''
    set -euo pipefail
    export HOME=/home/wh1le
    export PATH=${pkgs.lib.makeBinPath [ pkgs.git pkgs.gnumake pkgs.coreutils pkgs.util-linux pkgs.bash pkgs.python3 ]}
      ${pkgs.bash}/bin/bash ${./setup-dotfiles.sh}
    touch /home/wh1le/.dotfiles-setup-done
    '';
  };
}
