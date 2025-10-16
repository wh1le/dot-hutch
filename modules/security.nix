{
  pkgs,
  config,
  # userName,
  ...
}:

let
  systemKey = "SHA256:ob2Q6YKiQPsESpyB2ko4Gs8bgA+iZXP23cWYm0n7Kbk wh1le@pc";
in
{
  security = {
    sudo.enable = true;
  };
  services.openssh.enable = true;

  # "secret.age".publicKeys = [ systemKey ];

  # age = {
  #   identityPaths = [
  #     "${config.home.homeDirectory}/nix/configs/users/me/configs/ssh/keys/agenix-me"
  #   ];
  #   secrets = {
  #     freshrss_api_key = {
  #       file = ./secrets/users/me/rss/freshrss_api_key.age;
  #       path = "${config.home.homeDirectory}/.secrets/rss/secrets";
  #     };
  #   };
  # };

  environment.systemPackages = with pkgs; [
    openssl
    agenix-cli
  ];
}
