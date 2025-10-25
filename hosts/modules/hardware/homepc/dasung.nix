{ ... }:
{
  # 1. Add the udev rule
  services.udev.extraRules = ''
    SUBSYSTEM=="i2c-dev", KERNEL=="i2c-5", GROUP="video", MODE="0660"
  '';

  # 2. Add your user to the "video" group
  #    (Replace "wh1le" with your actual username)
  users.users.wh1le = {
    # ... other user settings
    extraGroups = [
      "wheel"
      "video"
    ]; # Add "video" here
  };
}
