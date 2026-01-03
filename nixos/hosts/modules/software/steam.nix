{ config, pkgs, unstable, ... }:
with pkgs;
let
  patchDesktop =
    pkg: appName: from: to:
    lib.hiPrio (
      pkgs.runCommand "$patched-desktop-entry-for-${appName}" { } ''
        ${coreutils}/bin/mkdir -p $out/share/applications
        ${gnused}/bin/sed 's#${from}#${to}#g' < ${pkg}/share/applications/${appName}.desktop > $out/share/applications/${appName}.desktop
      ''
    );

  GPUOffloadApp = pkg: desktopName: patchDesktop pkg desktopName "^Exec=" "Exec=nvidia-offload ";
in
{
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    gamescopeSession.enable = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  services.monado = {
    enable = true;
    defaultRuntime = true; # Register as default OpenXR runtime
  };

  systemd.user.services.monado.environment = {
    STEAMVR_LH_ENABLE = "1";
    XRT_COMPOSITOR_COMPUTE = "1";
  };

  boot.kernelPatches = [
    {
      name = "amdgpu-ignore-ctx-privileges";
      patch = pkgs.fetchpatch {
        name = "cap_sys_nice_begone.patch";
        url = "https://github.com/Frogging-Family/community-patches/raw/master/linux61-tkg/cap_sys_nice_begone.mypatch";
        hash = "sha256-Y3a0+x2xvHsfLax/uwycdJf3xLxvVfkfDVqjkxNaYEo=";
      };
    }
  ];

  programs.alvr = {
    enable = false;
    package = unstable.alvr;
    openFirewall = true;
  };

  networking.firewall.allowedUDPPorts = [
    9943
    9944
    10400
    27037
  ];

  # Optional if you want TCP open too:
  networking.firewall.allowedTCPPorts = [
    9943
    9944
    27036
  ];

  environment.sessionVariables = {
    # Your existing variables...
    LIBVA_DRIVER_NAME = "radeonsi";
    GDK_BACKEND = "wayland,x11,*";
  };

  security.wrappers."vrcompositor-launcher" = {
    owner = "root";
    group = "root";
    capabilities = "cap_sys_nice+ep";
    source = "/home/wh1le/.local/share/Steam/steamapps/common/SteamVR/bin/linux64/vrcompositor-launcher";
  };

  # Needed for SteamVR
  programs.steam.extraCompatPackages = with unstable; [
    proton-ge-bin
  ];


  hardware.steam-hardware.enable = true;

  # steamVR launch options
  # QT_QPA_PLATFORM=xcb __NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia %command% --gpu-number=1
  environment.systemPackages = with pkgs; [
    (GPUOffloadApp steam "steam")
    unstable.wivrn
    unstable.wlx-overlay-s
  ];
}
