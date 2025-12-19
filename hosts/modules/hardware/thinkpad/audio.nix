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

    extraConfig.pipewire."99-low-power" = {
      "context.properties" = {
        "default.clock.rate" = 48000;
        "default.allowed-rates" = [ 44100 48000 96000 ];
        "default.clock.quantum" = 1024;
        "default.clock.min-quantum" = 1024;
        "default.clock.max-quantum" = 8192;
        "default.clock.quantum-limit" = 8192;
      };
    };
  };

  services.upower.enable = true;

  environment.systemPackages = [
    pkgs.alsa-utils
    pkgs.pavucontrol
    pkgs.ncmpcpp
    pkgs.pulseaudio
    pkgs.pulsemeeter # Note: ensure you use either pkgs or unstable consistently
  ];
}
