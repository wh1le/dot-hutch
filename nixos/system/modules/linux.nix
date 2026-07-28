{ pkgs, config, ... }: {
  services.udev.extraRules = ''
    KERNEL=="uinput", GROUP="ydotool", MODE="0660"
  '';

  programs = {
    zsh = {
      enable = true;
      enableGlobalCompInit = false;
      promptInit = "";
      enableLsColors = false;
    };

    appimage.enable = true;

    direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableZshIntegration = false; # handled in user zshrc
    };
  };

  users.users.${config.my.username}.shell = pkgs.zsh;

  environment.variables = {
    EDITOR = "nvim";
    TERMINAL = "kitty";
  };

  environment.pathsToLink = [ "/share/nix-direnv" ];

  i18n = {
    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
      LC_MESSAGES = "en_US.UTF-8";
      LC_COLLATE = "en_US.UTF-8";
      LANGUAGE = "en_US.UTF-8";
      LC_ALL = "en_US.UTF-8";
      LC_CTYPE = "en_US.UTF-8";
    };
    defaultLocale = "en_US.UTF-8";
    extraLocales = [
      "en_US.UTF-8/UTF-8"
    ];
  };

  environment.systemPackages = [
    pkgs.libgcc

    pkgs.usbutils
    pkgs.libinput

    pkgs.gptfdisk
    pkgs.parted
    pkgs.gparted
    pkgs.efibootmgr
    pkgs.hfsprogs

    pkgs.lm_sensors

    pkgs.inotify-tools
    pkgs.libnotify

    pkgs.libva-utils
    pkgs.wiremix

    pkgs.busybox
    pkgs.pciutils

    pkgs.v4l-utils

    pkgs.below # systemd
    pkgs.wifitui
    pkgs.sysz
    pkgs.playwright-mcp
    pkgs.playwright-driver.browsers

    pkgs.psmisc # provides 'killall', 'pstree', general utilities

    pkgs.ffmpeg_6-full
    pkgs.dig

    # pkgs.systemctl-tui
    # pkgs.sysz
    # pkgs.lazyjournal
  ];
}
