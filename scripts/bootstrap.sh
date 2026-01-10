#!/usr/bin/env bash
set -eu

SECRETS_DEV="${SECRETS_DEV:-/dev/sda}"

SECRETS_MNT="/run/media/nixos/secrets"
SSH_KEY_NAME="${SSH_KEY_NAME:-secrets_installer_key}"
SECRETS_REPO="${SECRETS_MNT}/secrets.git"

TARGET_HOST="${TARGET_HOST:-}"
TARGET_USER="${TARGET_USER:-}"

# Overlay repositories for environment-specific configs (private, work, etc.)
# Format: space-separated "name:repo" pairs
# First entry = PRIMARY (base layer), subsequent entries overlay on top
#
# Example:
#   DOT_REPOS="base:git@github.com:user/dotfiles.git work:git@github.com:user/dot-work.git"
#
# This lets you keep public configs in one repo and layer private/work-specific
# overrides without forking or branching.
DOT_REPOS="${DOT_REPOS:-public:git@github.com:wh1le/dot-hutch.git}"

has_secrets_drive() {
  [[ -b "$SECRETS_DEV" ]]
}

has_secrets_mounted() {
  mountpoint -q "$SECRETS_MNT" 2>/dev/null
}

has_secrets_repo() {
  [[ -d /mnt/etc/secrets ]]
}

has_ssh_key() {
  [[ -f "${SECRETS_MNT}/Files/${SSH_KEY_NAME}" ]]
}

needs_ssh_for_repos() {
  [[ "$DOT_REPOS" == *"git@"* ]]
}

mount_secrets_usb() {
  !has_secrets_drive && echo "No secrets drive at $SECRETS_DEV" && return 0

  has_secrets_mounted && echo "Already mounted at $SECRETS_MNT" && return 0

  local name="secrets"

  sudo mkdir -p "$SECRETS_MNT"
  sudo cryptsetup open "$SECRETS_DEV" "$name"
  sudo mount "/dev/mapper/${name}" "$SECRETS_MNT"
  sudo chown -R "${USER}:users" "$SECRETS_MNT"

  echo "Secrets unlocked at $SECRETS_MN"
}

generate_empty_sops() {
  if ! command -v age-keygen &>/dev/null; then
    nix shell nixpkgs#age nixpkgs#sops --command bash -c "$(declare -f generate_sops); generate_sops"
    return
  fi

  sudo mkdir -p /mnt/var/lib/sops-nix/secrets

  sudo age-keygen -o /mnt/var/lib/sops-nix/keys.txt
  local pub_key=$(sudo grep -oP "public key: \K.*" /mnt/var/lib/sops-nix/keys.txt)

  sudo tee /mnt/var/lib/sops-nix/secrets/.sops.yaml >/dev/null <<EOF
creation_rules:
  - path_regex: .*
    key_groups:
      - age:
          - $pub_key
EOF

  cat <<EOF >/tmp/sops_template.yaml
openweathermap: your_open_weather_api_key
email: youremail
searx_secret_key: your_secret_searx_key
disroot:
  nextcloud:
    user: your_user
    password: password
  rclone:
    password: your_password
    salt: salts
EOF

  SOPS_AGE_KEY_FILE=/mnt/var/lib/sops-nix/keys.txt \
	  sudo -E sops --encrypt --age "$pub_key" /tmp/sops_template.yaml \
	  | sudo tee /mnt/var/lib/sops-nix/secrets/nix.yaml >/dev/null

  rm /tmp/sops_template.yaml

  sudo chown -R root:root /mnt/var/lib/sops-nix
  sudo chmod 700 /mnt/var/lib/sops-nix /mnt/var/lib/sops-nix/secrets
  sudo chmod 600 /mnt/var/lib/sops-nix/keys.txt /mnt/var/lib/sops-nix/secrets/nix.yaml

  echo "SOPS setup complete."
  echo "Public key: $pub_key"
  echo "Edit secrets: sudo SOPS_AGE_KEY_FILE=/var/lib/sops-nix/keys.txt sops /var/lib/sops-nix/secrets/nix.yaml"
}

clone_secrets_to_installation() {
  !has_secrets_mounted && echo "No secrets mounted, secrets repo" && return 0
  ! -d "${SECRETS_REPO}" && echo "No secrets repo at ${SECRETS_REPO}" && return 0

  has_secrets_repo && echo "~/.secrets already exists" && return 0

  git clone "$SECRETS_REPO" ~/.secrets
  echo "Cloned secrets repo"
}

link_main_nixos_configuration() {
  [[ -z "${PRIMARY_PATH:-}" ]] && echo "No repos defined"
  [[ ! -d "$PRIMARY_PATH" ]] && echo "Primary repo not found at $PRIMARY_PATH"

  sudo ln -sfn "$PRIMARY_PATH" /etc/nixos
  echo "Linked $PRIMARY_PATH → /etc/nixos"
}

run_disko() {
  local host="${1:-$TARGET_HOST}"

  echo "⚠ This will ERASE the disk defined in disko config for '$host'. Continue? [y/N]"
  read -r confirm
  [[ "$confirm" != "y" ]] && return 0

  local disko_target="${host}"
  echo "→ Use full disk encryption? [Y/n]"
  read -r use_encryption

  [[ "$use_encryption" == "n" ]] && disko_target="${host}-noenc"

  sudo nix --experimental-features "nix-command flakes" \
	  run github:nix-community/disko -- --mode disko \
	  --flake "${PRIMARY_PATH}#${disko_target}"

  echo "Disko complete (target: ${disko_target})"
}

run_install() {
  local host="${1:-$TARGET_HOST}"
 
  [[ -z "$host" ]] && echo "No hostname specified. Use: $0 install <hostname>"
  [[ ! -d "$PRIMARY_PATH" ]] && echo "Primary repo not found at $PRIMARY_PATH"

  sudo nixos-install --flake "${PRIMARY_PATH}#${host}"

  echo "nixos-install complete"
}

deploy_bios_keys() {
  sudo mkdir -p /mnt/var/lib/sbctl
  sudo cp -r ~/.secrets/sbctl-keys-bios/* /mnt/var/lib/sbctl/
  sudo chown -R root:root /mnt/var/lib/sbctl

  sudo find /mnt/var/lib/sbctl -type d -exec chmod 700 {} \;
  sudo find /mnt/var/lib/sbctl -name "*.key" -exec chmod 600 {} \;
  sudo find /mnt/var/lib/sbctl -name "*.pem" -exec chmod 644 {} \;

  echo "sbctl keys copied to target"
}

case "${1:-}" in
disko)
  run_disko "${2:-}"
  ;;
install)
  run_install "${2:-}"
  ;;
copy-secrets)
  deploy_bios_keys
  ;;
generate-empty-sops)
  generate_empty_sops
  ;;
full)
  link_main_nixos_configuration
  generate_empty_sops
  run_disko "${2:-}"
  run_install "${2:-}"
  echo "✓ Install complete."
  echo "→ Reboot into your new system"
  ;;
full-with-secrets)
  mount_secrets_usb
  clone_secrets_to_installation
  link_main_nixos_configuration
  run_disko "${2:-}"
  run_install "${2:-}"
  echo "✓  Install complete. Nixos configuration can be found at /etc/nixos."
  ;;
status)
  show_summary
  ;;
*)
