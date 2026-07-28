{ pkgs, inputs, ... }:
let
  emojiEmbeddedBitmapConf = pkgs.writeTextDir "etc/fonts/conf.d/54-emoji-embeddedbitmap.conf" ''
    <?xml version="1.0"?>
    <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
    <fontconfig>
      <match target="font">
        <test name="family" compare="eq"><string>Apple Color Emoji</string></test>
        <edit name="embeddedbitmap" mode="assign"><bool>true</bool></edit>
      </match>
      <match target="font">
        <test name="family" compare="eq"><string>Twitter Color Emoji</string></test>
        <edit name="embeddedbitmap" mode="assign"><bool>true</bool></edit>
      </match>
      <match target="font">
        <test name="family" compare="eq"><string>Noto Color Emoji</string></test>
        <edit name="embeddedbitmap" mode="assign"><bool>true</bool></edit>
      </match>
    </fontconfig>
  '';
in
{
  fonts = {
    packages = with pkgs; [
      atkinson-hyperlegible-next
      atkinson-hyperlegible-mono
      twitter-color-emoji

      nerd-fonts.jetbrains-mono
      nerd-fonts.symbols-only
      noto-fonts
      noto-fonts-color-emoji

      inputs.apple-emoji.packages.${pkgs.stdenv.hostPlatform.system}.default

      nerd-fonts.fantasque-sans-mono
      nerd-fonts.hack
      nerd-fonts.fira-code
      iosevka # upstream be5invis Iosevka, clean family "Iosevka" (no nerd icons)
      nerd-fonts.iosevka
      nerd-fonts.iosevka-term
      nerd-fonts.iosevka-term-slab
      material-symbols
    ];

    fontconfig.enable = true;
    fontconfig.confPackages = [ emojiEmbeddedBitmapConf ];

    fontconfig.defaultFonts = {
      serif = [ "PragmataPro" ];
      sansSerif = [ "PragmataPro" ];
      monospace = [ "PragmataPro Mono" ];
      emoji = [ "Apple Color Emoji" ];
    };

    # fontconfig.localConf = builtins.readFile ../../scripts/fontconfig-local.xml;
  };
}
