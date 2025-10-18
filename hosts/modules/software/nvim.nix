{
  pkgs,
  ...
}:

# TODO:
# kulala.nvim
# https://github.com/kawre/leetcode.nvim

{
  environment.systemPackages = with pkgs; [
    # Main dependencies
    neovim
    ripgrep
    lua5_1
    lua51Packages.luarocks
    lua54Packages.luarocks
    tree-sitter

    # LSP Servers
    lua-language-server
    bash-language-server
    vscode-langservers-extracted # ships: vscode-html-language-server vscode-css-language-server vscode-json-language-server vscode-eslint-language-server

    yaml-language-server

    ruby_3_4

    typescript-language-server
    # typescript
    vscode-langservers-extracted
    pyright
    ruff
    taplo
    marksman
    nil
    typos-lsp

    # Neovim python package
    (python3.withPackages (ps: [
      # NeoVim
      ps.pynvim
      ps.debugpy

      ps.requests
    ]))

    # Formatters
    codespell
    black
    isort
    prettierd
    eslint
    stylua
    shfmt
    shellcheck
    nixfmt-rfc-style
  ];
}
