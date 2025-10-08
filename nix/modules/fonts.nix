{
  pkgs,
  ...
}:

{
  fonts = {
    packages = with pkgs; [
      atkinson-hyperlegible
      nerd-fonts.jetbrains-mono
      nerd-fonts.atkynson-mono
      noto-fonts-color-emoji
      noto-fonts-emoji
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

  environment.systemPackages = with pkgs; [
    nerd-font-patcher
  ];
}
