{pkgs, ...}:{
  services.xserver = {
    enable = true;

    displayManager.lightdm.enable = true;

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

  services.displayManager.autoLogin.user = "pihole";
  services.displayManager.autoLogin.enable = true;


  fonts = {
    packages = with pkgs; [
      dejavu_fonts
      noto-fonts
      noto-fonts-emoji
      liberation_ttf
      atkinson-hyperlegible
      atkinson-hyperlegible-next
      nerd-fonts.jetbrains-mono
      nerd-fonts.atkynson-mono
      noto-fonts-color-emoji
      noto-fonts-emoji
    ];
    fontconfig = {
      enable = true;  # ensure system-wide fonts
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

  hardware.graphics.enable = true;

  programs.zsh.enable = true;

  environment.systemPackages = with pkgs; [
    dmenu
    kitty
    firefox

    git
    tmux
    neovim

    htop
    nano
    nmap

    nettools
    iputils
    unzip
    usbutils
  ];
}
