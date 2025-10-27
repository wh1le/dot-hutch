{pkgs, self, ...}:
{
  sops.secrets = {
    user_password_file = {
      sopsFile = "${self}/secrets/default.yaml";
      key = "khole/user/password";
      owner = "root";
      group = "root";
      mode = "0400";
			neededForUsers = true;
    };

  };

  users = {
    mutableUsers = true;

    users.pihole = {
      initialPassword = "hackme";
      isNormalUser = true;
      extraGroups = [ "wheel" "video" "input" ];
      shell = pkgs.zsh;
    };
  };
}
