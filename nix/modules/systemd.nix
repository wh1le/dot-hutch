{ }:
{
  systemd = {
    # TODO: Fix me or move to home manager
    # dotfiles-setup = {
    #   description = "Dotfiles bootstrap";
    #   wantedBy = [ "multi-user.target" ];
    #   wants = [ "network-online.target" ];
    #   after = [
    #     "network-online.target"
    #     "NetworkManager-wait-online.service"
    #   ];
    #
    #   unitConfig.ConditionPathExists = "!${dotFilesFlagFilePath}";
    #
    #   # serviceConfig = {
    #   #  Type = "oneshot";
    #   #  User = "${mainUser}";
    #   #  WorkingDirectory = "/home/${mainUser}";
    #   #};
    #
    #   serviceConfig = {
    #     Type = "oneshot";
    #     User = "wh1le";
    #     WorkingDirectory = "/home/wh1le/dot";
    #     PrivateNetwork = false;
    #     ProtectSystem = "strict";
    #     ProtectHome = "read-only";
    #     ReadWritePaths = [
    #       "/home/${mainUser}/dot"
    #       "/tmp"
    #     ];
    #   };
    #
    #   script = ''
    #     set -euo pipefail
    #     export PATH=${
    #       pkgs.lib.makeBinPath [
    #         pkgs.git
    #         pkgs.gnumake
    #         pkgs.coreutils
    #         pkgs.util-linux
    #         pkgs.bash
    #         pkgs.python3
    #       ]
    #     }
    #     mkdir -p -- "${dotFilesFlagPath}"
    #     ${pkgs.bash}/bin/bash ${../scripts/deploy-dotfiles.sh} ${mainUser}
    #   '';
    # };
  };
};
  }
