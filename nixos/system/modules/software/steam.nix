{ pkgs, config, ... }: {
  # Run it before launch
  # sudo setcap CAP_SYS_NICE=eip ~/.local/share/Steam/steamapps/common/SteamVR/bin/linux64/vrcompositor-launcher

  # VRChat launch options
  # WINEDLLOVERRIDES="iyuv_32=" __GL_SYNC_TO_VBLANK=0 WINE_GST_DECODER_PLUGIN_RANK="vaapih264dec:MAX" gamemoderun %command%   --enable-hw-video-decoding

  programs.gamemode.enable = true;
  # programs.gamemode.settings = {
  #   general.renice = 10;
  #   gpu.apply_gpu_optimisations = "accept-responsibility";
  #   gpu.gpu_device = 0;
  #   gpu.nv_powermizer_mode = 1;
  # };

  # programs.gamescope = {
  #   enable = true;
  #   capSysNice = true;
  # };

  # systemd.services.steamvr-setcap = {
  #   description = "Set CAP_SYS_NICE on SteamVR vrcompositor-launcher";
  #   wantedBy = [ "multi-user.target" ];
  #   unitConfig.ConditionPathExists = "${config.users.users.${config.my.username}.home}/.local/share/Steam/steamapps/common/SteamVR/bin/linux64/vrcompositor-launcher";
  #   serviceConfig = {
  #     Type = "oneshot";
  #     ExecStart = "${pkgs.libcap}/bin/setcap CAP_SYS_NICE=eip ${config.users.users.${config.my.username}.home}/.local/share/Steam/steamapps/common/SteamVR/bin/linux64/vrcompositor-launcher";
  #   };
  # };

  services.wivrn = {
    enable = true;
    openFirewall = true;
    autoStart = true;

    # WiVRn needs cudaSupport to hardware-encode via NVENC — without this it
    # won't GPU-encode the stream to the Quest. Your system-wide CUDA isn't
    # enough; the package itself must be built with it.
    package = pkgs.wivrn.override { cudaSupport = true; };

    config = {
      enable = true;
      json = {
        application = [
          pkgs.wayvr
          "--openxr"
        ];
      };
    };
  };

  programs.steam = {
    enable = true;
    # package = pkgs.steam.override {
    #   extraProfile = ''
    #     export PROTON_ENABLE_NVAPI=1
    #     export DXVK_ENABLE_NVAPI=1
    #   '';
    # };

    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    gamescopeSession.enable = true;
    localNetworkGameTransfers.openFirewall = true;
    extraPackages = with pkgs; [
      noto-fonts
      qt5.qtwayland
      qt5.qtmultimedia
      SDL2
      udev
      cudaPackages.cuda_cudart
      cudaPackages.cuda_nvrtc
      openxr-loader
      nvidia-vaapi-driver
      fuse
    ];
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };

  hardware.steam-hardware.enable = true;

  systemd.user.services.sunshine.environment.LD_LIBRARY_PATH = "/run/opengl-driver/lib";

  services.envfs.enable = true;

  environment.sessionVariables = {
    XR_RUNTIME_JSON = "${
      config.users.users.${config.my.username}.home
    }/.local/share/Steam/steamapps/common/SteamVR/steamxr_linux64.json";
    # VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/nvidia_icd.x86_64.json";
  };

  networking.firewall.allowedUDPPorts = [
    27015
    27031
    27032
    27033
    27034
    27035
    27036
    3478
    4379
    4380
  ];
  networking.firewall.allowedTCPPorts = [
    27036
    27037
  ];

  environment.systemPackages = [
    pkgs.vulkan-tools
    pkgs.vulkan-loader
    pkgs.lutris
    pkgs.protonup-qt
    pkgs.sidequest
    pkgs.protonplus
  ];
}
