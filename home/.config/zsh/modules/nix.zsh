export NIX_SHELL_PRESERVE_PROMPT=1
export NIX_CONFIG="experimental-features = nix-command flakes"

_nixos_update_public() {
	if nix flake metadata /etc/nixos --json 2>/dev/null | grep -q '"PUBLIC"'; then
		sudo nix --extra-experimental-features "nix-command flakes" flake update PUBLIC --flake /etc/nixos >/dev/null 2>&1
	fi
}

zsh-rebuild-cache() {
	mkdir -p "$HOME/.cache/zsh"
	compinit -d "$ZSH_COMPDUMP"
	fzf --zsh >"$HOME/.cache/zsh/fzf-init.zsh"
	direnv hook zsh >"$HOME/.cache/zsh/direnv-init.zsh"
	echo "zsh caches rebuilt"
}

_nixos_rebuild() {
	sudo nixos-rebuild "$1" --flake "/etc/nixos#$(hostnamectl --static 2>/dev/null || hostname)" &&
		zsh-rebuild-cache
}

ns() {
	if _nixos_update_public && _nixos_rebuild switch; then
		local gen=$(readlink /nix/var/nix/profiles/system | sed 's/.*-\([0-9]*\)-link/\1/')
		notify-send -i system-software-update "NixOS Build Number #${gen} Released" "$gen"
	fi
}

nb() {
	if _nixos_update_public && _nixos_rebuild boot; then
		local gen=$(readlink /nix/var/nix/profiles/system | sed 's/.*-\([0-9]*\)-link/\1/')
		notify-send -i system-software-update "NixOS Build Number #${gen} (boot)" "$gen"
	fi
}

ntest() {
	_nixos_update_public && _nixos_rebuild dry-build
}

nd() {
	local host=$(hostnamectl --static 2>/dev/null || hostname)
	_nixos_update_public &&
		nix build "/etc/nixos#nixosConfigurations.${host}.config.system.build.toplevel" --out-link /tmp/nixos-diff &&
		echo "\n=== Package changes ===" &&
		nix store diff-closures /run/current-system /tmp/nixos-diff &&
		echo "\n=== Service changes ===" &&
		sudo nixos-rebuild dry-activate --flake "/etc/nixos#${host}" 2>&1 | tail -n +2
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

nc() {
	_nixos_update_public && nix flake check /etc/nixos
}

alias nix_clean="sudo nix-collect-garbage -d"

alias nix_releases_list="sudo nixos-rebuild list-generations"
alias nix_releases_switch="sudo nixos-rebuild switch --generation"

alias nso="~/.local/bin/public/menu/options/nix-search-options"
alias nsh="~/.local/bin/public/menu/options/nix-search-home-options"
alias nsp="~/.local/bin/public/menu/options/nix-search-packages"
