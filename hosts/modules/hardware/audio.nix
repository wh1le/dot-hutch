{ pkgs, ... }:

{
  services.pipewire = {
    enable = true;
    wireplumber.enable = true;
    pulse.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    jack.enable = false; # Uncomment the following line if you want to use JACK applications
    extraConfig.pipewire."context.properties" = {
      "default.clock.rate" = 44100;
      "default.clock.quantum" = 128;
      "default.clock.min-quantum" = 64;
      "default.clock.max-quantum" = 256;
    };
  };

  # hardware.pulseaudio.enable = true;
  # services.pulseaudio = {
  #   package = pkgs.pulseaudioFull;
  # };

  services.upower.enable = true;

  environment.systemPackages = with pkgs; [
    pavucontrol
    ncmpcpp
    pulseaudio
  ];
}
