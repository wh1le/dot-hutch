{ pkgs, ... }:
{
  environment.systemPackages = [
    (pkgs.writeShellApplication {
      name = "difit";
      runtimeInputs = [
        pkgs.nodejs
        pkgs.git
        pkgs.gh
      ];

      text = ''
        exec npx --yes --package=difit@5.0.12 -- difit "$@"
      '';
    })
  ];
}
