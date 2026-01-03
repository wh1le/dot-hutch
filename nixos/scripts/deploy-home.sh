#!/usr/bin/env bash

set -eu

export HOME="/home/${1:?username required}"
export DOT_FILES="${HOME}/dot/nix-public"

export XDG_CONFIG_SRC="$DOT_FILES/home/.config"
export XDG_CONFIG_DEST="$HOME/.config"

home_dirs=(
	Documents
	Videos
	Music
	Cloud
	code
	Projects
	Virtualization
)

create_home_defaults() {
	for home_dirs in "${dirs[@]}"; do
		mkdir -p "$HOME/$dir"
	done

	echo "home directories created: ${dirs[*]}"

	mkdir -p "$HOME/.local/bin"

	echo "user scripts directory created"
}

link_scripts() {
	ln -sfn "$DOT_FILES/home/.zprofile" "$HOME/.zprofile"
	ln -sfn "$DOT_FILES/home/.zprofile" "$HOME/.profile"
	ln -sfn "$DOT_FILES/home/.zshenv" "$HOME/.zshenv"

	echo "shell profiles linked"

	ln -sfn "$HOME/dot/files/home/.local/bin/public" "$HOME/.local/bin/public"
	ln -sfn "$HOME/dot/files/home/.local/share/darkman" "$HOME/.local/share/darkman"

	echo "scripts linked"
}

fix_existing_link() {
	local target=$1
	local item=$2

	if [ -L "$target" ]; then

		local current="$(readlink -- "$target")"

		if [ "$current" = "$item" ]; then
			return 1
		else
			rm -f -- "$target"

			echo "removed outdated link: $target"
		fi
	elif [ -e "$target" ]; then
		rm -rf -- "$target"

		echo "directory detected: $target, deleting..."
	fi

	return 0
}

link_xdg_config() {
	mkdir -p "$XDG_CONFIG_DEST"

	for item in "$XDG_CONFIG_SRC"/*; do
		local name=$(basename "$item")
		local target="$XDG_CONFIG_DEST/$name"

		fix_existing_link "$target" "$item" || continue

		ln -s "$item" "$target"

		echo "linked: $name"
	done
}

clone_dependencies() {
	git -C "$DOT_FILES" submodule update --init --recursive
	echo "submodules initialized"
}

create_home_defaults
link_scripts
link_xdg_config
clone_dependencies
