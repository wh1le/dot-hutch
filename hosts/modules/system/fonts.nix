{ pkgs, ... }:
{
  # List installed fonts:
  # fc-list |  cut -d: -f2 | cut -d',' -f1  | sed 's/^[[:space:]]*//'  | sort -u
  # show styles:
  # fc-list 'FiraCode Nerd Font' -f '%{style}\n' | sort -u

  fonts = {
    packages = with pkgs; [
      atkinson-hyperlegible-next
      atkinson-hyperlegible-mono
      twitter-color-emoji

      nerd-fonts.jetbrains-mono
      noto-fonts-color-emoji

      # Trying fonts
      nerd-fonts.fantasque-sans-mono
      nerd-fonts.hack
      nerd-fonts.fira-code
      nerd-fonts.iosevka
      nerd-fonts.iosevka-term
      nerd-fonts.iosevka-term-slab
    ];

    fontconfig.enable = true;

    fontconfig.defaultFonts = {
      # Used for: print-like text, books, long reading.
      serif = [ "Atkinson Hyperlegible Next" ];
      # Used for: UI, websites, clean modern text.
      sansSerif = [ "Atkinson Hyperlegible Next" ];
      # Used for: code, terminals, alignment-sensitive text.
      monospace = [
        "Atkinson Hyperlegible Next"
        "JetBrainsMono Nerd Font"
      ];
      # emoji = [ "Noto Color Emoji" ];
      emoji = [ "Twitter Color Emoji" ];
    };

    # generates at /etc/fonts/local.conf
    fontconfig.localConf = builtins.readFile (../../../assets/fontconfig-local.xml);
  };
}
