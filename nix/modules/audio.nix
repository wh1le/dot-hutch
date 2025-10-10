{ pkgs, ... }:

{
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    jack.enable = true; # Uncomment the following line if you want to use JACK applications
    extraConfig.pipewire."context.properties" = {
      "default.clock.rate" = 48000;
      "default.clock.quantum" = 128;
      "default.clock.min-quantum" = 64;
      "default.clock.max-quantum" = 256;
    };
    wireplumber.enable = true;
  };

  environment.systemPackages = with pkgs; [
    pavucontrol
    mpd
    ncmpcpp
    pulseaudio
  ];
}
