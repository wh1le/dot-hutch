export NIX_SHELL_PRESERVE_PROMPT=1

# Nix
alias nix_test="sudo nixos-rebuild test --flake /etc/nixos#$(shell hostnamectl --static 2>/dev/null || hostname) --update-input PUBLIC"
alias nix_switch="sudo nixos-rebuild switch --flake /etc/nixos#$(shell hostnamectl --static 2>/dev/null || hostname) --update-input PUBLIC"
alias nix_build="sudo nixos-rebuild build --flake /etc/nixos#$(shell hostnamectl --static 2>/dev/null || hostname) --update-input PUBLIC"
alias nix_boot="sudo nixos-rebuild boot --flake /etc/nixos#$(shell hostnamectl --static 2>/dev/null || hostname) --update-input PUBLIC"

nix_dependencies() {
  local pkg="$1"
  [[ -z "$pkg" ]] && {
    echo "usage: nix_dependencies <attr>"
    return 2
  }
  NIX_CONFIG="experimental-features = nix-command flakes" \
    nix why-depends /tmp/sys \
    "$(nix build --no-link --print-out-paths "nixpkgs#$pkg")"
}

alias nix_clean="sudo nix-collect-garbage -d"

alias nix_releases_list="sudo nixos-rebuild list-generations"
alias nix_releases_switch="sudo nixos-rebuild switch --generation"

alias no='manix "" | grep "^# " | sed "s/^# \(.*\) (.*/\1/;s/ (.*//;s/^# //" | fzf --preview="manix '\''{}'\''" | xargs manix'
alias np="nix-search-tv print | fzf --preview 'nix-search-tv preview {}' --scheme history | wl-copy"
