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
        "dondai44423/donsetch"
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
      "dondai44423/donsetch"
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
      "awscli"
      "ca-certificates"
      "ccusage"
      "docker-credential-helper-ecr"
      "felixkratz/formulae/borders"
      "felixkratz/formulae/sketchybar"
      "fswatch"
      "git-filter-repo"
      "git-gui"
      "graphviz"
      "hunk"
      "jq"
      "k1low/tap/tbls"
      "libyaml"
      "logcli"
      "nono"
      "nowplaying-cli"
      "opencode"
      "pam-reattach"
      "pi-coding-agent"
      "pnpm"
      "rover"
      "rsync"
      "switchaudio-osx"
      "uv"
      "yarn"
      "donsetch"
      "workmux"
      "lima"
    ];
    global = {
      brewfile = true;
    };
    onActivation = {
      autoUpdate = false;
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
