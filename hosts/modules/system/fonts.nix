{
  pkgs,
  ...
}:

{
  fonts = {
    packages = with pkgs; [
      atkinson-hyperlegible
      atkinson-hyperlegible-next
      nerd-fonts.jetbrains-mono
      nerd-fonts.atkynson-mono
      noto-fonts-color-emoji
      noto-fonts-emoji
    ];

    fontconfig = {
      enable = true;
      subpixel.rgba = "none";

      hinting = {
        enable = true;
        style = "full";
      };

      antialias = false;

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
