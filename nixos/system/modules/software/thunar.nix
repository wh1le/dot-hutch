{ pkgs, ... }:
{
  programs.thunar = {
    enable = true;
    plugins = with pkgs; [
      thunar-volman
      thunar-archive-plugin
      thunar-media-tags-plugin
    ];
  };
  programs.xfconf.enable = true;
  services.tumbler.enable = false;

  environment.systemPackages = [ pkgs.xfce4-exo ]; # exo-open for terminal/browser launching

  # Mount/eject without a password for wheel members.
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      var YES = polkit.Result.YES;
      var permission = {
        "org.freedesktop.udisks2.filesystem-mount": YES,
        "org.freedesktop.udisks2.filesystem-mount-system": YES,
        "org.freedesktop.udisks2.encrypted-unlock": YES,
        "org.freedesktop.udisks2.eject-media": YES,
        "org.freedesktop.udisks2.power-off-drive": YES,
      };
      if (subject.isInGroup("wheel") && permission[action.id]) {
        return YES;
      }
    });
  '';
}
