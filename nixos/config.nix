{ lib, ... }:
{
  options.my.username = lib.mkOption {
    type = lib.types.str;
    default = "wh1le";
    description = "Primary user login name.";
  };

  options.my.repoUrls.public = lib.mkOption {
    type = lib.types.str;
    default = "https://github.com/wh1le/dot-hutch.git";
    description = "URL of the public dotfiles repository.";
  };
}
