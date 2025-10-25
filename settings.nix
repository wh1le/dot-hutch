{ ... }:

{
  system = "x86_64-linux";
  autoUpdateFrequency = "monthly";

  # Change based on deployment machine
  mainUser = "wh1le";

  # Git
  name = "Nikita Miloserdov";

  timezone = "Europe/Lisbon";

  locales = [
    "en_US.UTF-8/UTF-8"
    "ru_RU.UTF-8/UTF-8"
  ];

  defaultLocale = "en_US.UTF-8";

  dotFilesRepo = "git@github.com:wh1le/dot-files.git";
  nixFilesRepo = "git@github.com:wh1le/dot-nix.git";
}
