#!/usr/bin/env bash
set -eu

# === Config ===
SECRETS_DEV="${SECRETS_DEV:-/dev/sda}"
SECRETS_INDEX="${SECRETS_INDEX:-1}"
SECRETS_MNT="/mnt/secrets${SECRETS_INDEX}"
SSH_KEY_NAME="${SSH_KEY_NAME:-secrets_installer_key}"
SECRETS_REPO="${SECRETS_MNT}/secrets.git"
TARGET_USER="${TARGET_USER:-$(whoami)}"
TARGET_HOST="${TARGET_HOST:-}"

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
  local name="secrets${SECRETS_INDEX}"
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

clone_secrets() {
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

link_config() {
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
  sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko --flake "${PRIMARY_PATH}#${host}"
  ok "Disko complete"
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

copy_secrets_to_target() {
  if has_sbctl_keys; then
    sudo mkdir -p /mnt/var/lib/sbctl
    sudo cp -r ~/.secrets/sbctl-keys-bios/* /mnt/var/lib/sbctl/
    sudo chown -R root:root /mnt/var/lib/sbctl
    sudo chmod 600 /mnt/var/lib/sbctl/keys/*/*.key
    ok "sbctl keys copied to target"
  else
    skip "No sbctl keys to copy"
  fi

  if has_secrets_repo; then
    sudo mkdir -p "/mnt/home/${TARGET_USER}/.secrets"
    sudo cp -r ~/.secrets/* "/mnt/home/${TARGET_USER}/.secrets/"
    sudo chown -R 1000:users "/mnt/home/${TARGET_USER}/.secrets"
    ok "Secrets copied to target"
  else
    skip "No secrets repo to copy"
  fi
}

copy_dot_files_to_target() {
  detect_primary
  sudo mkdir -p "/mnt/home/${TARGET_USER}/dot"
  for entry in $DOT_REPOS; do
    local name="${entry%%:*}"
    local src=~/dot/nix-${name}
    local dest="/mnt/home/${TARGET_USER}/dot/nix-${name}"
    if [[ -d "$src" ]]; then
      sudo cp -r "$src" "$dest"
      ok "Copied nix-${name} to target"
    fi
  done
  sudo chown -R 1000:users "/mnt/home/${TARGET_USER}/dot"
  sudo ln -sfn "/mnt/home/${TARGET_USER}/dot/nix-${PRIMARY_NAME}" /mnt/etc/nixos
  ok "Linked config in target"
}

deploy_home() {
  detect_primary
  local target="${1:-}"
  local home_base="${target}/home/${TARGET_USER}"
  local deploy_script="${PRIMARY_PATH}/scripts/deploy-home.sh"

  if [[ ! -x "$deploy_script" ]]; then
    fail "deploy-home.sh not found at $deploy_script"
  fi

  if [[ -n "$target" ]]; then
    # Installing to target - just create dirs, full deploy after boot
    local home_dirs=(Documents Videos Music Cloud code Projects Virtualization)
    for dir in "${home_dirs[@]}"; do
      sudo mkdir -p "${home_base}/${dir}"
    done
    sudo chown -R 1000:users "${home_base}"
    ok "Home directories created in target"
    log "Run 'deploy-home' after reboot for full setup"
  else
    # Running system - full deploy
    "$deploy_script" "${TARGET_USER}"
    ok "Home deployed"
  fi
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
  clone_secrets
  ;;
clone)
  clone_dot_files
  ;;
link)
  link_config
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
  copy_secrets_to_target
  ;;
copy-dots)
  copy_dot_files_to_target
  ;;
deploy-home)
  deploy_home "${2:-}"
  ;;
full)
  mount_secrets
  setup_ssh
  clone_secrets
  clone_dot_files
  link_config
  run_disko "${2:-}"
  run_install "${2:-}"
  copy_secrets_to_target
  copy_dot_files_to_target
  deploy_home /mnt
  show_summary
  echo "✓ Install complete."
  has_sbctl_keys && echo "→ Reboot and enable Secure Boot in BIOS"
  echo "→ After reboot run: $0 deploy-home"
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
  status        Show detected configuration
  full <host>   Complete install (auto-skips unavailable features)
  deploy-home   Deploy dotfiles (run after reboot)

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
