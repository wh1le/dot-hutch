{
  pkgs,
  ...
}:

{
  virtualisation.podman.enable = true;
  virtualisation.podman.defaultNetwork.settings.dns_enabled = true;
  virtualisation.oci-containers.backend = "podman";

  # users.groups.podman = {
  #   name = "podman";
  # };
  users.users.wh1le.extraGroups = [ "podman" ];

  environment.systemPackages = with pkgs; [
    podman
    podman-tui # Terminal mgmt UI for Podman
    passt # For Pasta rootless networking
  ];
}
