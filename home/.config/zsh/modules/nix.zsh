export NIX_SHELL_PRESERVE_PROMPT=1
export NIX_CONFIG="experimental-features = nix-command flakes"

# Nix
# alias nix_test="sudo nixos-rebuild test --flake /etc/nixos#$(shell hostnamectl --static 2>/dev/null || hostname) --update-input PUBLIC"
# alias nix_switch="sudo nixos-rebuild switch --flake /etc/nixos#$(shell hostnamectl --static 2>/dev/null || hostname) --update-input PUBLIC"
# alias nix_build="sudo nixos-rebuild build --flake /etc/nixos#$(shell hostnamectl --static 2>/dev/null || hostname) --update-input PUBLIC"
# alias nix_boot="sudo nixos-rebuild boot --flake /etc/nixos#$(shell hostnamectl --static 2>/dev/null || hostname) --update-input PUBLIC"

ns() {
  if sudo nix --extra-experimental-features "nix-command flakes" flake update PUBLIC --flake /etc/nixos &&
    sudo nixos-rebuild switch --flake "/etc/nixos#$(hostnamectl --static 2>/dev/null || hostname)"; then
    local gen=$(readlink /nix/var/nix/profiles/system | sed 's/.*-\([0-9]*\)-link/\1/')
    notify-send -i system-software-update "NixOS Build Number #${gen} Released" "$generation"
  else
    notify-send -u critical --expire-time=5000 -i dialog-error "NixOS" "Build failed"
  fi
}

nix_find_bin() {
  nix-build '<nixpkgs>' -A $1 --no-out-link
}

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

alias nso="~/.local/bin/public/menu/options/nix-search-options"
alias nsh="~/.local/bin/public/menu/options/nix-search-home-options"
alias nsp="~/.local/bin/public/menu/options/nix-search-packages"
