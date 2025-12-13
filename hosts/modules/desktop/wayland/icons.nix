{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    colloid-icon-theme
  ];
}
