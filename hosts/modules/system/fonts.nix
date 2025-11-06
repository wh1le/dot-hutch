{
  pkgs,
  ...
}:

{
  fonts = {
    packages = with pkgs; [
      atkinson-hyperlegible-next
      atkinson-hyperlegible-mono

      nerd-fonts.jetbrains-mono

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

        serif = [ "Atkinson Hyperlegible Next" ];
        sansSerif = [ "Atkinson Hyperlegible Next" ];
        monospace = [
          "Atkinson Hyperlegible Next"
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
