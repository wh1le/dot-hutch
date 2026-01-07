{ pkgs, unstable, ... }: {
  systemd.tmpfiles.rules = [
    "d /home/wh1le/.secrets 0700 wh1le users -"
    "d /home/wh1le/.secrets/passwords 0700 wh1le users -"
  ];

  environment.systemPackages = [
    pkgs.qrtool

    (unstable.pass.withExtensions (exts: [
      exts.pass-import
      exts.pass-update
      exts.pass-otp
    ]))
  ];
}
