{ pkgs, ... }:
{
  home.packages = with pkgs; [
    gcc
    gnumake
    autoconf
    pkg-config
    rustc
    openssl.dev
    libyaml
    readline
    zlib.dev
    gdbm
    libffi
    gmp
    ncurses
    libpq
    postgresql
    libxml2
    libxslt
    redis
    chromedriver
    watchman
    imagemagick
    yarn
  ];

  home.sessionVariables = {
    RUBY_CONFIGURE_OPTS = builtins.concatStringsSep " " [
      "--with-openssl-dir=${pkgs.openssl.dev}"
      "--with-readline-dir=${pkgs.readline.dev}"
      "--with-libyaml-dir=${pkgs.libyaml}"
      "--with-zlib-dir=${pkgs.zlib.dev}"
    ];
    CFLAGS = "-I${pkgs.zlib.dev}/include";
    LDFLAGS = "-L${pkgs.zlib.out}/lib";
  };
}
