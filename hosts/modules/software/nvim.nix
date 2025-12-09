{ pkgs, unstable, ... }:
{
  environment.systemPackages = [
    unstable.vimPlugins.lazy-nvim
    unstable.neovim
    pkgs.ripgrep
    pkgs.lua5_1
    pkgs.lua51Packages.luarocks
    pkgs.lua54Packages.luarocks
    pkgs.tree-sitter

    (pkgs.python3.withPackages (ps: [
      ps.pynvim
    ]))

    # LSP Servers
    pkgs.lua-language-server
    pkgs.bash-language-server
    pkgs.vscode-langservers-extracted # ships: vscode-html-language-server vscode-css-language-server vscode-json-language-server vscode-eslint-language-server
    pkgs.yaml-language-server
    pkgs.ruby_3_4
    pkgs.typescript-language-server

    # typescript
    pkgs.vscode-langservers-extracted
    pkgs.pyright
    pkgs.ruff
    pkgs.taplo
    pkgs.marksman
    pkgs.nil
    pkgs.typos-lsp

    # Formatters
    pkgs.codespell
    pkgs.black
    pkgs.isort
    pkgs.prettierd
    pkgs.eslint
    pkgs.stylua
    pkgs.shfmt
    pkgs.shellcheck
    pkgs.nixfmt-rfc-style
    pkgs.nixpkgs-fmt

    # kulala plugin
    pkgs.libxml2_13
    pkgs.grpcurl
    pkgs.websocat
  ];
}
