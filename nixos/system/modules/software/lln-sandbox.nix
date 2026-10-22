{
  pkgs,
  config,
  inputs,
  ...
}:
let
  sandbox = inputs.agent-sandbox.lib.${pkgs.stdenv.hostPlatform.system};

  username = config.my.username;
  home = config.users.users.${username}.home;
  uid = config.users.users.${username}.uid;
  runtimeDir = "/run/user/${toString uid}";

  pi = pkgs.writeShellScriptBin "pi" ''
    exec ${home}/.local/bin/pi "$@"
  '';

  pi-sandboxed = sandbox.mkSandbox {
    pkg = pi;
    binName = "pi";
    outName = "pi-sandboxed";

    allowedPackages = sandbox.commonTools ++ [
      pkgs.distrobox
      pkgs.podman
      pkgs.passt
      pkgs.slirp4netns
      pkgs.fuse-overlayfs
    ];

    allowUnixSockets = true;

    rwDirs = [
      "$HOME/.pi"
      "$HOME/.config/containers"
      "$HOME/.local/share/containers"
      "$HOME/.local/share/distrobox"
      runtimeDir
    ];

    roDirs = [
      "$HOME/.local/bin"
      "$HOME/.local/share/pnpm"
    ];

    roFiles = [
      "$HOME/.config/git/config"
    ];

    env = {
      DEEPSEEK_API_KEY = "$DEEPSEEK_API_KEY";
      XDG_RUNTIME_DIR = runtimeDir;
    };

    allowedDomains = {
      "api.deepseek.com" = "*";
      "registry.npmjs.org" = [
        "GET"
        "HEAD"
      ];
      "raw.githubusercontent.com" = [
        "GET"
        "HEAD"
      ];
      "api.github.com" = [
        "GET"
        "HEAD"
      ];
    };
  };
in
{
  environment.systemPackages = [ pi-sandboxed ];
}
