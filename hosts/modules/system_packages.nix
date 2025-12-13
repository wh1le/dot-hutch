{ unstable, pkgs, ... }: {
  environment.systemPackages = [
    pkgs.socat
  ];
}
