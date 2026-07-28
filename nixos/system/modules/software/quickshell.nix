{ pkgs, inputs, ... }:

let
  quickshell = inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default;
  quickshell-wrapped = pkgs.stdenv.mkDerivation {
    name = "quickshell-wrapped";
    meta.description = "Quickshell with bundled Qt deps";

    dontUnpack = true;
    dontConfigure = true;
    dontBuild = true;

    nativeBuildInputs = [
      pkgs.makeWrapper
      pkgs.qt6.wrapQtAppsHook
    ];

    buildInputs = with pkgs; [
      quickshell
      gsettings-desktop-schemas
      kdePackages.qtwayland
      kdePackages.qtpositioning
      kdePackages.qtlocation
      kdePackages.syntax-highlighting
      kdePackages.kirigami
      kdePackages.kdialog
      qt6.qtbase
      qt6.qtdeclarative
      qt6.qt5compat
      qt6.qtimageformats
      qt6.qtmultimedia
      qt6.qtpositioning
      qt6.qtquicktimeline
      qt6.qtsensors
      qt6.qtsvg
      qt6.qttools
      qt6.qttranslations
      qt6.qtwayland
    ];

    installPhase = ''
      mkdir -p $out/bin
      makeWrapper ${quickshell}/bin/quickshell $out/bin/quickshell \
        --set QT_QPA_PLATFORMTHEME gnome \
        --prefix XDG_DATA_DIRS : ${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}
    '';
  };
in
{
  environment.systemPackages = [
    quickshell-wrapped

    pkgs.j4-dmenu-desktop
    pkgs.inotify-tools
    pkgs.yq
  ];

  fonts.packages = [
    pkgs.material-symbols
  ];
}
