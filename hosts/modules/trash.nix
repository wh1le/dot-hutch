{ pkgs, ... }:
{
  # Add trash-cli for command line trash management
  environment.systemPackages = with pkgs; [
    trash-cli # trash-put, trash-list, trash-restore, trash-empty
  ];

  # Or use a service to auto-empty trash
  systemd.user.services.trash-cleanup = {
    description = "Empty trash older than 30 days";
    serviceConfig.ExecStart = "${pkgs.trash-cli}/bin/trash-empty 30";
  };

  systemd.user.timers.trash-cleanup = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "weekly";
      Persistent = true;
    };
  };

}
