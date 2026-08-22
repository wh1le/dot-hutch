{
  imports = [
    ./darwin/system.nix
    ./darwin/security.nix
    ./darwin/certificates.nix
    ./darwin/defaults.nix
    ./darwin/keyboard.nix
    ./darwin/packages.nix

    ../software/sketchybar.nix
    ../homebrew.nix
  ];
}
