{ pkgs, unstable, ... }:

{
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    wireplumber.enable = true;
    pulse.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    jack.enable = false; # Uncomment the following line if you want to use JACK applications

    extraConfig.pipewire."context.properties" = {
      "default.clock.rate" = 44100;
      "default.allowed-rates" = [
        44100
        48000
      ];
      "default.clock.quantum" = 128;
      "default.clock.min-quantum" = 32;
      "default.clock.max-quantum" = 128;
      "default.clock.quantum-limit" = 8192;
    };
  };

  # hardware.pulseaudio.enable = true;
  # services.pulseaudio = {
  #   package = pkgs.pulseaudioFull;
  # };

  services.upower.enable = true;

  environment.systemPackages = [
    pkgs.alsa-utils
    pkgs.pavucontrol
    pkgs.ncmpcpp
    pkgs.pulseaudio
    unstable.pulsemeeter
  ];
}
