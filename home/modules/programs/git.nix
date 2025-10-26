{ config, ... }:
{
  sops.secrets.email = {
    sopsFile = ./secrets/default.yaml;
    format = "yaml";
    key = "email";
    owner = "wh1le";
    mode = "0400";
  };

  sops.templates."git-user" = {
    owner = "wh1le";
    mode = "0400";
    content = ''
      [user]
        email = {{ .email }}
    '';
  };

  programs.git = {
    enable = true;
    userName = "Nikita Miloserdov";
    includes = [ { path = config.sops.templates."git-user".path; } ];
  };
}
