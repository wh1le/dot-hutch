{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.neovim

    pkgs.ripgrep

    pkgs.lua5_1
    pkgs.lua51Packages.luarocks
    pkgs.lua-language-server

    pkgs.tree-sitter

    pkgs.perl

    pkgs.bash-language-server
    pkgs.vscode-langservers-extracted
    pkgs.yaml-language-server
    pkgs.typescript-language-server
    pkgs.clippy
    pkgs.vtsls
    pkgs.tailwindcss-language-server
    pkgs.prettier
    pkgs.vscode-langservers-extracted
    pkgs.pyright
    pkgs.ruff
    pkgs.taplo
    pkgs.marksman
    pkgs.nil
    pkgs.typos-lsp

    pkgs.codespell
    pkgs.black
    pkgs.isort
    pkgs.prettierd
    pkgs.eslint
    pkgs.stylua
    pkgs.shfmt
    pkgs.shellcheck
    pkgs.nixfmt
    pkgs.nixpkgs-fmt

    pkgs.rustfmt
    pkgs.rust-analyzer

    pkgs.libxml2_13
    pkgs.grpcurl
    pkgs.websocat

    pkgs.gopls
    pkgs.golangci-lint

    pkgs.librsvg
  ];
}
