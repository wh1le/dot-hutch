{ pkgs, lib, ... }:
let
  kver = pkgs.linuxPackages_latest.kernel.version;
in
{
  boot = lib.mkMerge [
    (lib.mkIf ((lib.versionAtLeast kver "5.17") && (lib.versionOlder kver "6.1")) {
      kernelParams = [ "initcall_blacklist=acpi_cpufreq_init" ];
      kernelModules = [ "amd-pstate" ];
    })
    (lib.mkIf ((lib.versionAtLeast kver "6.1") && (lib.versionOlder kver "6.3")) {
      kernelParams = [ "amd_pstate=passive" ];
    })
    (lib.mkIf (lib.versionAtLeast kver "6.3") {
      kernelParams = [ "amd_pstate=active" ];
    })
  ];
}
