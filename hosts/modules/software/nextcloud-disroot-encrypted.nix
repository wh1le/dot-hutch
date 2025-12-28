{ unstable, pkgs, config, ... }:
{
  systemd.tmpfiles.rules = [
    "d /home/wh1le/Cloud 0755 wh1le users -"
    "d /home/wh1le/Cloud/disroot 0755 wh1le users -"
  ];

  environment.systemPackages = [
    pkgs.rclone
  ];

  programs.fuse.userAllowOther = true;
  sops.secrets."disroot/nextcloud/user" = { owner = "wh1le"; mode = "0400"; };
  sops.secrets."disroot/nextcloud/password" = { owner = "wh1le"; mode = "0400"; };
  sops.secrets."disroot/rclone/password" = { owner = "wh1le"; mode = "0400"; };
  sops.secrets."disroot/rclone/salt" = { owner = "wh1le"; mode = "0400"; };

  systemd.services.disroot-rclone = {
    description = "Rclone Disroot encrypted mount";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "simple";
      User = "wh1le";
      Group = "users";
      AmbientCapabilities = [ "CAP_SYS_ADMIN" ];
      PrivateDevices = false;
      ExecStartPre = [
        "-${pkgs.util-linux}/bin/umount -l /home/wh1le/Cloud/disroot"
        "-${pkgs.fuse}/bin/fusermount -uz /home/wh1le/Cloud/disroot"
      ];
      ExecStart = toString (pkgs.writeShellScript "rclone-mount" ''
        export RCLONE_CONFIG="/home/wh1le/.config/rclone/rclone.conf"
        export RCLONE_CONFIG_DISROOT_USER=$(cat /run/secrets/disroot/nextcloud/user)
        export RCLONE_CONFIG_DISROOT_PASS=$(${pkgs.rclone}/bin/rclone obscure "$(cat /run/secrets/disroot/nextcloud/password)")
        export RCLONE_CONFIG_DISROOTCRYPT_PASSWORD=$(${pkgs.rclone}/bin/rclone obscure "$(cat /run/secrets/disroot/rclone/password)")
        export RCLONE_CONFIG_DISROOTCRYPT_PASSWORD2=$(${pkgs.rclone}/bin/rclone obscure "$(cat /run/secrets/disroot/rclone/salt)")

        exec ${pkgs.rclone}/bin/rclone mount disrootcrypt: "/home/wh1le/Cloud/disroot" \
          --cache-dir /home/wh1le/.cache/rclone \
          --vfs-cache-mode full \
          --vfs-write-back 30s \
          --vfs-cache-max-age 24h \
          --vfs-cache-max-size 1G \
          --dir-cache-time 10m \
          --vfs-refresh \
          --poll-interval 5m \
          --vfs-cache-poll-interval 10m \
          --retries 3 \
          --retries-sleep 10s \
          --timeout 60s \
          --contimeout 30s \
          --allow-non-empty  \
          --allow-other
      '');
      ExecStop = "${pkgs.fuse}/bin/fusermount -u /home/wh1le/Cloud/disroot";
      Restart = "on-failure";
      RestartSec = "10s";
    };
  };
}
