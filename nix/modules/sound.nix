{ pkgs }:

{
  pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true; # Uncomment the following line if you want to use JACK applications
    extraConfig.pipewire."context.properties" = {
      "default.clock.rate" = 48000;
      "default.clock.quantum" = 128;
      "default.clock.min-quantum" = 64;
      "default.clock.max-quantum" = 256;
    };
  };
  services.wireplumber.enable = true;

  environment.systemPackages = with pkgs; [
    pavucontrol
  ];
}
