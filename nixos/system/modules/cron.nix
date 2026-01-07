{ pkgs, ... }: {
  services.cron = {
    enable = true;
    systemCronJobs = [
      "*/5 * * * * wh1le /home/wh1le/.local/bin/public/pass/git-watcher-pull"
      "0 0 */5 * * wh1le ${pkgs.cliphist}/bin/cliphist wipe"
      "0 1 */5 * * wh1le ${pkgs.trash-cli}/bin/trash-empty -f 5"
    ];
  };
}
