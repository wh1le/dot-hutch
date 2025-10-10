{
  pkgs,
  ...
}:
{

  environment.systemPackages = with pkgs; [
    gnumake
    pkg-config
    cmake
    clang
    libgcc

    mercurial
    nodejs_24
    perl
    ruby_3_4

    # Neovim python package
    (python3.withPackages (ps: [
      # NeoVim
      ps.pynvim
      ps.debugpy

      ps.requests
    ]))
  ];
}
