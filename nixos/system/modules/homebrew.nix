{ config, pkgs, ... }:
let
  caBundle = "/etc/ssl/certs/nix-corp-bundle.pem";
in
{
  nix-homebrew = {
    enable = true;
    enableRosetta = pkgs.stdenv.hostPlatform.isAarch64;
    user = config.my.username;
    autoMigrate = true;
    trust = {
      taps = [
        "nikitabobko/tap"
        "felixkratz/formulae"
      ];
      formulae = [
        "felixkratz/formulae/sketchybar"
        "felixkratz/formulae/borders"
      ];
      casks = [
        "nikitabobko/tap/aerospace"
      ];
    };
  };

  environment.variables = {
    HOMEBREW_GIT_PATH = "/Library/Developer/CommandLineTools/usr/bin/git";
  };

  homebrew = {
    enable = true;
    taps = [
      "nikitabobko/tap"
      "FelixKratz/formulae"
    ];
    casks = [
      "codex"
      "claude-code"
      "ghostty"
      "hammerspoon"
      "nikitabobko/tap/aerospace"
      "font-sketchybar-app-font"
      "font-hack-nerd-font"
      "font-sf-pro"
      "font-sf-mono"
      "sf-symbols"
    ];
    brews = [
      "asdf"
      "mysql"
      "pam-reattach"
      "pi-coding-agent"
      "switchaudio-osx"
      "nowplaying-cli"
      "FelixKratz/formulae/sketchybar"
      "FelixKratz/formulae/borders"
      "ccusage"
      "git-gui"
    ];
    global = {
      brewfile = true;
    };
    onActivation = {
      autoUpdate = true;
      upgrade = false;
      cleanup = "none";
      extraEnv = {
        HOMEBREW_GIT_PATH = "/Library/Developer/CommandLineTools/usr/bin/git";
        NIX_SSL_CERT_FILE = caBundle;
        SSL_CERT_FILE = caBundle;
        GIT_SSL_CAINFO = caBundle;
        HOMEBREW_NO_ANALYTICS = "1";
        HOMEBREW_NO_REQUIRE_TAP_TRUST = "1";
      };
    };
  };
}
