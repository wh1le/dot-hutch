#!/usr/bin/env bash
set -eu

# === Config ===
SECRETS_DEV="${SECRETS_DEV:-/dev/sda}"
SECRETS_MNT="/run/media/nixos/secrets"
SSH_KEY_NAME="${SSH_KEY_NAME:-secrets_installer_key}"
SECRETS_REPO="${SECRETS_MNT}/secrets.git"
TARGET_USER="${TARGET_USER:-$(whoami)}"
TARGET_HOST="${TARGET_HOST:-}"

ROOT_USERS="${ROOT_USERS:-wh1le}"

# Space separated "name:repo" pairs - first becomes PRIMARY
DOT_REPOS="${DOT_REPOS:-public:git@github.com:wh1le/nix-public.git}"

PRIMARY_PATH=""
PRIMARY_NAME=""

# === Detection ===
has_secrets_drive() {
	[[ -b "$SECRETS_DEV" ]]
}

has_secrets_mounted() {
	mountpoint -q "$SECRETS_MNT" 2>/dev/null
}

has_secrets_repo() {
	[[ -d ~/.secrets ]]
}

has_sbctl_keys() {
	[[ -d ~/.secrets/sbctl-keys-bios ]]
}

has_ssh_key() {
	[[ -f "${SECRETS_MNT}/Files/${SSH_KEY_NAME}" ]]
}

needs_ssh_for_repos() {
	[[ "$DOT_REPOS" == *"git@"* ]]
}

# === Functions ===
log() { echo "→ $*"; }
ok() { echo "✓ $*"; }
skip() { echo "⊘ $* (skipped)"; }
fail() {
	echo "✗ $*" >&2
	return 1
}

mount_secrets() {
	if ! has_secrets_drive; then
		skip "No secrets drive at $SECRETS_DEV"
		return 0
	fi
	if has_secrets_mounted; then
		ok "Already mounted at $SECRETS_MNT"
		return 0
	fi
	local name="secrets"
	sudo mkdir -p "$SECRETS_MNT"
	sudo cryptsetup open "$SECRETS_DEV" "$name"
	sudo mount "/dev/mapper/${name}" "$SECRETS_MNT"
	sudo chown -R "${USER}:users" "$SECRETS_MNT"
	ok "Secrets unlocked at $SECRETS_MNT"
}

setup_ssh() {
	if ! has_secrets_mounted; then
		if needs_ssh_for_repos; then
			fail "SSH repos defined but no secrets mounted"
		fi
		skip "No secrets mounted, SSH setup"
		return 0
	fi
	if ! has_ssh_key; then
		skip "No SSH key found at ${SECRETS_MNT}/Files/${SSH_KEY_NAME}"
		return 0
	fi
	mkdir -p ~/.ssh
	cp "${SECRETS_MNT}/Files/${SSH_KEY_NAME}" ~/.ssh/
	cp "${SECRETS_MNT}/Files/${SSH_KEY_NAME}.pub" ~/.ssh/
	chmod 600 ~/.ssh/"${SSH_KEY_NAME}"
	eval "$(ssh-agent -s)"
	ssh-add ~/.ssh/"${SSH_KEY_NAME}"
	ok "SSH key loaded"
}

clone_secrets_to_live_usb() {
	if ! has_secrets_mounted; then
		skip "No secrets mounted, secrets repo"
		return 0
	fi
	if [[ ! -d "${SECRETS_REPO}" ]]; then
		skip "No secrets repo at ${SECRETS_REPO}"
		return 0
	fi
	if has_secrets_repo; then
		ok "~/.secrets already exists"
		return 0
	fi
	git clone "$SECRETS_REPO" ~/.secrets
	ok "Cloned secrets repo"
}

clone_dot_files() {
	mkdir -p ~/dot
	local first=true
	for entry in $DOT_REPOS; do
		local name="${entry%%:*}"
		local repo="${entry#*:}"
		local path=~/dot/nix-${name}
		if [[ ! -d "$path" ]]; then
			git clone "$repo" "$path"
			ok "Cloned nix-${name}"
		else
			ok "~/dot/nix-${name} already exists"
		fi
		if $first; then
			PRIMARY_PATH="$path"
			PRIMARY_NAME="$name"
			first=false
		fi
	done
}

detect_primary() {
	local first=true
	for entry in $DOT_REPOS; do
		if $first; then
			local name="${entry%%:*}"
			PRIMARY_PATH=~/dot/nix-${name}
			PRIMARY_NAME="$name"
			first=false
		fi
	done
}

link_main_nixos_configuration() {
	detect_primary
	if [[ -z "${PRIMARY_PATH:-}" ]]; then
		fail "No repos defined"
	fi
	if [[ ! -d "$PRIMARY_PATH" ]]; then
		fail "Primary repo not found at $PRIMARY_PATH"
	fi
	sudo ln -sfn "$PRIMARY_PATH" /etc/nixos
	ok "Linked $PRIMARY_PATH → /etc/nixos"
}

setup_sbctl_keys() {
	if ! has_sbctl_keys; then
		skip "No sbctl keys found, secure boot"
		return 0
	fi
	sudo mkdir -p /var/lib/sbctl
	sudo cp -r ~/.secrets/sbctl-keys-bios/* /var/lib/sbctl/
	sudo chown -R root:root /var/lib/sbctl
	sudo chmod 600 /var/lib/sbctl/keys/*/*.key
	ok "sbctl keys installed"
}

run_disko() {
	detect_primary
	local host="${1:-$TARGET_HOST}"
	if [[ -z "$host" ]]; then
		fail "No hostname specified. Use: $0 disko <hostname>"
	fi
	if [[ ! -d "$PRIMARY_PATH" ]]; then
		fail "Primary repo not found at $PRIMARY_PATH"
	fi

	echo "⚠ This will ERASE the disk defined in disko config for '$host'. Continue? [y/N]"
	read -r confirm
	[[ "$confirm" == "y" ]] || exit 1

	local disko_target="${host}"
	echo "→ Use full disk encryption? [y/N]"
	read -r use_encryption
	[[ "$use_encryption" == "y" ]] || disko_target="${host}-noenc"

	sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko --flake "${PRIMARY_PATH}#${disko_target}"
	ok "Disko complete (target: ${disko_target})"
}

run_install() {
	detect_primary
	local host="${1:-$TARGET_HOST}"
	if [[ -z "$host" ]]; then
		fail "No hostname specified. Use: $0 install <hostname>"
	fi
	if [[ ! -d "$PRIMARY_PATH" ]]; then
		fail "Primary repo not found at $PRIMARY_PATH"
	fi
	sudo nixos-install --flake "${PRIMARY_PATH}#${host}" --no-root-passwd
	ok "nixos-install complete"
}

deploy_bios_keys() {
	if has_sbctl_keys; then
		sudo mkdir -p /mnt/var/lib/sbctl/keys/{PK,KEK,db}
		sudo cp -r ~/.secrets/sbctl-keys-bios/* /mnt/var/lib/sbctl/
		sudo chown -R root:root /mnt/var/lib/sbctl
		sudo chmod 700 /mnt/var/lib/sbctl/keys
		sudo chmod 600 /mnt/var/lib/sbctl/keys/*/*.key
		sudo chmod 644 /mnt/var/lib/sbctl/keys/*/*.pem
		ok "sbctl keys copied to target"
	else
		skip "No sbctl keys to copy"
	fi
}

copy_dot_files_to_target() {
	detect_primary

	for user_home in /mnt/home/*/; do
		local user=$(basename "$user_home")
		[[ "$user" == "lost+found" ]] && continue

		local uid=$(stat -c %u "$user_home")
		sudo mkdir -p "${user_home}dot"

		for entry in $DOT_REPOS; do
			local name="${entry%%:*}"
			local src=~/dot/nix-${name}
			[[ -d "$src" ]] && sudo cp -r "$src" "${user_home}dot/nix-${name}" && ok "Copied nix-${name} to ${user}"
		done

		[[ -d ~/.secrets && " $ROOT_USERS " == *" $user "* ]] &&
			sudo cp -r ~/.secrets "${user_home}.secrets" &&
			sudo chown -R "${uid}:users" "${user_home}.secrets" &&
			ok "Copied .secrets to ${user}"

		sudo chown -R "${uid}:users" "${user_home}dot"
	done

	local primary_user="${TARGET_USER:-$(ls /mnt/home | grep -v lost+found | head -1)}"
	sudo ln -sfn "/mnt/home/${primary_user}/dot/nix-${PRIMARY_NAME}" /mnt/etc/nixos
	ok "Linked config in target"
}

show_summary() {
	echo ""
	echo "=== Install Summary ==="
	has_secrets_drive && echo "• Secrets drive: $SECRETS_DEV" || echo "• Secrets drive: none"
	has_sbctl_keys && echo "• Secure boot: enabled" || echo "• Secure boot: disabled"
	echo "• Primary config: ${PRIMARY_NAME:-unknown}"
	echo "• Target user: $TARGET_USER"
	echo "• Target host: ${TARGET_HOST:-<specify with arg>}"
	echo ""
}

# === Main ===
case "${1:-}" in
mount)
	mount_secrets
	;;
ssh)
	setup_ssh
	;;
clone-secrets)
	clone_secrets_to_live_usb
	;;
clone)
	clone_dot_files
	;;
link)
	link_main_nixos_configuration
	;;
sbctl)
	setup_sbctl_keys
	;;
disko)
	run_disko "${2:-}"
	;;
install)
	run_install "${2:-}"
	;;
copy-secrets)
	deploy_bios_keys
	;;
copy-dots)
	copy_dot_files_to_target
	;;
full)
	clone_dot_files
	link_main_nixos_configuration
	run_disko "${2:-}"
	run_install "${2:-}"
	copy_dot_files_to_target
	show_summary
	echo "✓ Install complete."
	echo "→ Reboot into your new system"
	;;
full-with-secrets)
	mount_secrets
	setup_ssh
	clone_secrets_to_live_usb
	clone_dot_files
	link_main_nixos_configuration
	run_disko "${2:-}"
	deploy_bios_keys
	run_install "${2:-}"
	copy_dot_files_to_target
	show_summary
	echo "✓  Install complete. Nixos configuration can be found at /etc/nixos."
	has_sbctl_keys && echo "→ Reboot and enable Secure Boot in BIOS"
	;;
status)
	detect_primary
	show_summary
	;;
*)
	cat <<EOF
NixOS Installer - Auto-detecting setup

Usage: $0 <command> [hostname]

Commands:
  status                     Show detected configuration
  full <host>                Complete install (auto-skips unavailable features)
  full-with-secrets <host>   Complete install (With Secrets Flash Drive)

Individual steps:
  mount         Mount encrypted secrets drive
  ssh           Setup SSH key from secrets
  clone-secrets Clone secrets repo
  clone         Clone dotfile repos
  link          Link primary config to /etc/nixos
  sbctl         Install secure boot keys
  disko <host>  Format disk (destructive!)
  install <host> Run nixos-install
  copy-secrets  Copy secrets to /mnt
  copy-dots     Copy dotfiles to /mnt

Environment:
  DOT_REPOS     "name:repo" pairs, first=primary
                (default: public:git@github.com:wh1le/nix-public.git)
  TARGET_USER   Username (default: current user)
  TARGET_HOST   Default hostname
  SECRETS_DEV   Secrets device (default: /dev/sda)

Examples:
  # Minimal public install
  DOT_REPOS="public:https://github.com/wh1le/nix-public.git" $0 full thinkpad

  # Full private install with secrets
  DOT_REPOS="private:git@github.com:wh1le/nix-private.git public:git@github.com:wh1le/nix-public.git" $0 full thinkpad
EOF
	exit 1
	;;
esac
