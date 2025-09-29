{ config, pkgs, ... }:

{
  system.stateVersion = "25.05";
  networking.hostName = "wh1le-vm";
  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "Europe/Lisbon";

  users.users.wh1le = {
    isNormalUser = true;
    home = "/home/wh1le";
    extraGroups = [ "networkmanager" "wheel" "audio" "video" "input" "tss" ];
    initialPassword = "hackme";
    shell = pkgs.zsh;
  };

  security.sudo.enable = true;
  security.sudo.wheelNeedsPassword = false;


  fonts.packages = with pkgs; [
    atkinson-hyperlegible
    jetbrains-mono
    noto-fonts-color-emoji
  ];


  programs.zsh.enable = true;
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # Screen sharing
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  };

  services.displayManager.ly.enable = true;

  services.xserver = {
      xkb = {
        layout = "us,ru";
        options = "grp:ctrl_space_toggle,ctrl:swapcaps";
      };
  };

  console.useXkbConfig = true;

  virtualisation = {
    memorySize = 4096;

    cores = 4;
    qemu.options = [ "-vga virtio" ];
  };

  # services = {
  #   # qemuGuest = { enable = true; };
  #   
  #   # I am not sure if I need it
  #   xserver = { # videoDrivers = ["nvidia"]; };
  # };


  # hardware.nvidia = {
  #   modesetting.enable = true;                # sets nvidia_drm.modeset=1
  #   open = true;                              # 4090 supported by open kernel module
  #   powerManagement.enable = true;
  #   nvidiaSettings = true;
  #   package = config.boot.kernelPackages.nvidiaPackages.stable;
  # };

  environment.systemPackages = with pkgs; [
    gnumake
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

    docker
    veracrypt

    firefox
    xfce.thunar
    zoom-us

    nerd-font-patcher
  ];
  system.activationScripts.setupDotFiles = {
    deps = ["users"];
    text = ''
    PATH=${pkgs.lib.makeBinPath [ pkgs.git pkgs.gnumake ]}

    echo "Running dotfiles setup as user wh1le..."

    # The inner double quotes are now treated as literal characters
    su wh1le -c "${./setup-dotfiles.sh}"
    '';
  };
}
