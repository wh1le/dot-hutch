{
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    # --- Neovim dependencies --- #
    neovim
    ripgrep
    lua5_1
    lua51Packages.luarocks
    lua54Packages.luarocks
    tree-sitter
    # --- Neovim dependencies --- #

    (python3.withPackages (ps: [
      # NeoVim
      ps.pynvim
      ps.debugpy
    ]))

    # --- LSP servers  ---  #
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
    # --- LSP servers  ---  #

    # --- code formmaters --- #
    codespell
    black
    isort
    prettierd
    eslint_d
    stylua
    shfmt
    shellcheck
    nixfmt-rfc-style
    # --- code formatters ---  #
  ];
}
