{ pkgs
, ...
}:
{
  services.xserver.xkb = {
    model = "thinkpad";
    layout = "us";
  };

  console.useXkbConfig = true;

  services.keyd = {
    enable = true;
    keyboards.default = {
      ids = [ "*" ];
      settings.main = {
        "`" = "102nd"; # ` becomes 
        "102nd" = "`"; # < becomes `
      };
    };
  };

  environment.systemPackages = with pkgs; [
    klavaro
    gtypist
  ];
}
