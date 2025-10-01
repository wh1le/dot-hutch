{
  config,
  lib,
  pkgs,
  self,
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
  ];

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

  programs.ssh = {
    startAgent = true;
    agentTimeout = "1h";
  };

  system.stateVersion = "25.05";
  time.timeZone = "Europe/Lisbon";
  i18n.defaultLocale = "en_US.UTF-8";

  security.sudo.enable = true;
  security.sudo.wheelNeedsPassword = false;

  fonts = {
    packages = with pkgs; [
      atkinson-hyperlegible
      jetbrains-mono
      noto-fonts-color-emoji
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

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  };

  services.xserver = {
    xkb = {
      layout = "us,ru";
      options = "grp:ctrl_space_toggle,ctrl:swapcaps";
    };
    # xkbOptions=
    videoDrivers = [ "nvidia" ];

  };

  services.displayManager.ly.enable = true;
  services.expressvpn.enable = true;
  services.openssh.enable = true;
  services.resolved.enable = true;

  programs.zsh.enable = true;

  # users.groups.keyd = {};
  # services.keyd = { enable = true; };

  environment.systemPackages = with pkgs; [
    bash
    zsh

    tree
    fzf
    tmux
    vim
    btop
    htop
    bluetui
    bluez

    # --- languages support   --- #
    mercurial
    nodejs_24
    perl
    ruby_3_4
    # --- languages support   --- #

    # --- Neovim dependencies --- #
    neovim
    ripgrep
    lua5_1
    lua51Packages.luarocks
    lua54Packages.luarocks
    tree-sitter
    # --- Neovim dependencies --- #

    # --- LSP servers  ---  #
    lua-language-server
    bash-language-server
    vscode-langservers-extracted
    yaml-language-server
    ruby-lsp
    rubocop
    typescript-language-server
    typescript
    vscode-langservers-extracted
    pyright
    ruff
    taplo
    marksman
    nil
    typos-lsp
    # --- LSP servers  ---  #

    # --- code formmaters --- #
    codespell
    black
    isort
    prettierd
    eslint_d
    stylua
    shfmt
    shellcheck
    nixfmt-rfc-style
    # --- code formatters ---  #

    git
    direnv
    nix-direnv

    kitty
    wezterm

    waybar
    hyprpaper
    wl-clipboard

    dunst

    veracrypt
    openssl

    gtk3
    gtk4
    yazi

    expressvpn

    wofi
    fastfetch

    firefox

    # Remove switch to lightweight
    kdePackages.dolphin
    zoom-us

    nerd-font-patcher

    # UI
    pywal16
    pywalfox-native

    # Ruby
    # openssl libyaml zlib readline autoconf bison pkg-config

    # C and make
    gnumake
    pkg-config
    cmake
    clang
    libgcc

    (python3.withPackages (ps: [
      # NeoVim
      ps.pynvim
      ps.debugpy
    ]))
  ];

  # system.activationScripts.pywalfox = {
  #   text = ''
  #     runuser -l wh1le -c '${pkgs.pywalfox-native}/bin/pywalfox install || true
  #   '';
  # };

  systemd.services.dotfiles-setup = {
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
}
