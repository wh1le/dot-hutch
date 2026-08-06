{ pkgs, ... }: {
  environment.systemPackages = [
    pkgs.gnumake
    pkgs.pkg-config
    pkgs.cmake
    pkgs.clang
    pkgs.mercurial

    pkgs.nodejs_24

    pkgs.ruby_4_0
    pkgs.rubyPackages_4_0.pry

    (pkgs.python3.withPackages (python: [
      python.requests

      # yazi
      python.numpy
      python.pillow

      # neovim
      python.pynvim
      python.debugpy
    ]))

    pkgs.ncdu # freespace
    pkgs.file
    pkgs.bzip2
    pkgs.unzip

    pkgs.trash-cli

    pkgs.sshfs

    pkgs.imagemagick
    pkgs.gifsicle

    pkgs.img2pdf
    pkgs.qpdf

    (pkgs.pass.withExtensions (exts: [
      exts.pass-otp
    ]))
  ];
}
