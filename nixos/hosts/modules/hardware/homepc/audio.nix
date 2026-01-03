{ pkgs, unstable, ... }:

{
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    wireplumber.enable = true;
    pulse.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    jack.enable = false;
    extraConfig.pipewire."context.properties" = {
      "default.clock.rate" = 48000;
      "default.allowed-rates" = [
        44100
        48000
        96000
        192000
      ];
      "default.clock.quantum" = 2048;
      "default.clock.min-quantum" = 1024;
      "default.clock.max-quantum" = 8192;
      "default.clock.quantum-limit" = 8192;

    };
  };

  services.upower.enable = true;

  environment.systemPackages = [
    pkgs.alsa-utils
    pkgs.pavucontrol
    pkgs.ncmpcpp
    pkgs.pulseaudio
    pkgs.pulsemeeter
  ];
}
