{ config, pkgs, ... }:
let
  caBundle = "/etc/ssl/certs/nix-corp-bundle.pem";
in
{
  environment.variables = {
    HOMEBREW_GIT_PATH = "/Library/Developer/CommandLineTools/usr/bin/git";
  };

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
        "k1low/tap/tbls"
      ];
      casks = [
        "nikitabobko/tap/aerospace"
      ];
    };
  };

  homebrew = {
    enable = true;
    taps = [
      "nikitabobko/tap"
      "felixkratz/formulae"
      "k1low/tap"
    ];
    casks = [
      "codex"
      "claude-code"
      "ghostty"
      "hammerspoon"
      "karabiner-elements"
      "nikitabobko/tap/aerospace"
      "font-sketchybar-app-font"
      "font-hack-nerd-font"
      "font-sf-pro"
      "font-sf-mono"
      "sf-symbols"
    ];
    brews = [
      "asdf"
      {
        name = "mysql";
        restart_service = "changed";
      }
      "pam-reattach"
      "pi-coding-agent"
      "switchaudio-osx"
      "nowplaying-cli"
      "felixkratz/formulae/sketchybar"
      "felixkratz/formulae/borders"
      "ccusage"
      "ca-certificates"
      "awscli"
      "docker-credential-helper-ecr"
      "fswatch"
      "git-filter-repo"
      "graphviz"
      "jq"
      "libyaml"
      "logcli"
      "pnpm"
      "rover"
      "rsync"
      "yarn"
      "k1low/tap/tbls"
      "git-gui"
      "opencode"
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
