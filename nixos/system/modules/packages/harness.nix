{
  pkgs,
  unstable,
  inputs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    unstable.rtk # compact bash tools calls
    pkgs.honcho

    # tests fail upstream at this rev (dashboard keymap + state store); drop doCheck until they pass
    (inputs.workmux.packages.${pkgs.stdenv.hostPlatform.system}.default.overrideAttrs (_: {
      doCheck = false;
    }))
  ];
}
