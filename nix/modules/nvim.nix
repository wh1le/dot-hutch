{
  pkgs,
  ...
}:

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
    vscode-langservers-extracted
    yaml-language-server
    ruby-lsp
    rubocop
    typescript-language-server
    typescript
    vscode-langservers-extracted
    pyright
    ruff
    taplo
    marksman
    nil
    typos-lsp

    # Formatters
    codespell
    black
    isort
    prettierd
    eslint_d
    stylua
    shfmt
    shellcheck
    nixfmt-rfc-style
  ];
}
