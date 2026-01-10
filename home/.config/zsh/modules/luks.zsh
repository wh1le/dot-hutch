#!/usr/bin/env bash

luks-list() {
  local simple="$1"

  if [[ ! simple ]]; then
    echo "=== LUKS Devices ==="
    echo ""
  fi

  sudo blkid -t TYPE=crypto_LUKS -o device 2>/dev/null | while read dev; do
    size=$(lsblk -no SIZE "$dev" 2>/dev/null | head -1)
    label=$(sudo blkid -s LABEL -o value "$dev" 2>/dev/null)
    mapper=$(lsblk -lno NAME,TYPE "$dev" 2>/dev/null | awk '$2=="crypt" {print $1}')

    if [[ simple ]]; then
        echo "$dev"
    else
      if [[ -n "$mapper" && -e "/dev/mapper/$mapper" ]]; then
        mount=$(findmnt -no TARGET "/dev/mapper/$mapper" 2>/dev/null)
        printf "%-12s %6s  %-12s  unlocked → /dev/mapper/%s %s\n" "$dev" "$size" "${label:--}" "$mapper" "${mount:+@ $mount}"
      else
        printf "%-12s %6s  %-12s  locked\n" "$dev" "$size" "${label:--}"
      fi
    fi
  done
}

secrets-health-check() {
  local a=${1:-/mnt/secrets}
  local b=${2:-/mnt/secrets2}

	local sum_a=$(find "$a" -type f ! -path "*.git/config" -exec md5sum {} + | sed "s|$a||g" | sort)
  local sum_b=$(find "$b" -type f ! -path "*.git/config" -exec md5sum {} + | sed "s|$b||g" | sort)


  if [[ "$sum_a" == "$sum_b" ]]; then
    echo "✓ Identical"
    return 0
  else
    echo "✗ Different:"
    diff <(echo "$sum_a") <(echo "$sum_b")
    return 1
  fi
}

secrets-is-monuted() {
  local index="$2"
  local name="secrets${index}"
  local mnt="/mnt/${name}"

  if mountpoint -q "$mnt" 2>/dev/null; then
    echo "✗ Already mounted at $mnt" >&2
    return 1
  fi

  return 0
}

secrets-mount() {
  local dev="${1:-}"
  local name="secrets${index}"
  local mnt="/mnt/${name}"

  if [[ ! "$dev" ]]; then
    dev=$(result=$(luks-list "simple") && wait && echo "$result"  |fzf)
  fi

  echo "$dev"

  if mountpoint -q "$mnt" 2>/dev/null; then
    echo "✗ Already mounted at $mnt" >&2
    return 1
  fi

  sudo mkdir -p "$mnt" || return 1
  sudo cryptsetup open "$dev" "$name" || return 1
  sudo mount "/dev/mapper/${name}" "$mnt" || return 1
  sudo chown -R "${USER}:users" "$mnt" || return 1
  echo "✓ Secrets unlocked at $mnt"
}

secrets-close() {
  local closed=0

  for mapper in /dev/mapper/secrets*; do
    [[ -e "$mapper" ]] || continue
    [[ "$mapper" =~ ^/dev/mapper/secrets[0-9]*$ ]] || continue

    local name="${mapper##*/}"
    local mnt="/mnt/${name}"

    sudo umount -f "$mnt" 2>/dev/null || sudo umount -l "$mnt"
    sync
    sudo cryptsetup close "$name" && {
      echo "✓ ${name} locked"
      ((closed++))
    }
  done

  ((closed)) || echo "✗ No secrets mounted" >&2
}

secrets-init-deploy() {
  local TARGET=${1:-/}
  local SECRETS_MOUNT_POINT=${2:-/mnt/secrets}
  local HOST=${3:-$(hostname)}

  local secrets_dir="${TARGET}$HOME/.secrets"
  local remote_repo="${SECRETS_MOUNT_POINT}/secrets.git"
  local user_passwords_path="${TARGET}$HOME/.secrets/passwords"
  local ssh_keys_path="${SECRETS_MOUNT_POINT}/Files/.ssh_$HOST"

  echo "Are you Sure? \n"
  echo "1 Target: $TARGET"
  echo "2 Secrets mount point: ${SECRETS_MOUNT_POINT}"
  echo "3 Target Host: ${HOST}, Current Host: $(hostname)\n"
  printf "type [y/n]: "
  read RESPONSE

  if [[ $RESPONSE =~ ^[Yy]$ ]] then
    if [[ ! secrets-is-monuted ]]; then
      secrets-mount drive
    else
      echo "Secrets mount point found."
    fi

    echo "deploying ssh ..."
    mkdir -p $HOME/.ssh
    sudo cp -rp "$ssh_keys_path"/* "$HOME/.ssh"
    ssh-add "$HOME/.ssh/id_rsa"
    echo "[ok] ssh deployed"

    if [[ ! -d $secrets_dir ]]; then
      [[ -d $secrets_dir ]] && echo "${secrets_dir} exists skipping"

      echo "deploying $HOME/.secrets"

      git clone $remote_repo $secrets_dir
      sudo chown -R root:root ~/.secrets
      sudo chmod -R 700 ~/.secrets
      sudo chmod 755 ~/.secrets

      sudo chown -R wh1le:users ~/.secrets/passwords

      echo "[ok] cloned to $secrets_dir"
    fi

    echo "deploying gpg keys"
    gpg-restore-keys
    gpg-restart
    echo gpg-keys
    echo "[ok] gpg keys deployed"

    echo "deploying sops"
    sudo cp -p $secrets_dir/sops/nix.yaml $TARGET/var/lib/sops-nix/secrets/nix.yaml
    sudo cp -p $secrets_dir/sops/age/keys.txt $TARGET/var/lib/sops-nix/keys.txt

    echo "[ok] sops deployed"

    echo "deploying passwords"
    local latest_backup=$(ls -1t $SECRETS_MOUNT_POINT/Backups/passwords | head -n1)
    cp -rp "$SECRETS_MOUNT_POINT/Backups/passwords"/$latest_backup $HOME/.secrets/passwords
    cd $HOME/.secrets/passwords && git pull
    echo "[ok] passwords deployed"
  else
    return 1
  fi
}

secrets-sync() {
  local secrets_dir="$HOME/.secrets"
  local remote_repo="/mnt/secrets/secrets.git"

  [[ ! -d "$remote_repo" ]] && echo "✗ Mount flash first" && return 1

  cd "$secrets_dir" || return 1

  git stash -q --include-untracked 2>/dev/null || true

  # pull remote
  if git pull --rebase; then
    echo "✓ Pulled from flash"
  else
    echo "✗ Pull failed, resolve conflicts"
    git stash pop -q 2>/dev/null || true
    return 1
  fi

  git stash pop -q 2>/dev/null || true
  if ! git diff-index --quiet HEAD -- 2>/dev/null; then
    git add -A
    git commit -m "sync: $(hostname) $(date +%Y-%m-%d)"
    git push && echo "✓ Pushed to flash"
  else
    echo "✓ Already in sync"
  fi
}

secrets-backup() {
  local primary="/mnt/secrets"
  local backup="${1:-/mnt/secrets-backup}"

  [[ ! -d "$primary/secrets.git" ]] && echo "✗ Mount primary flash first" && return 1
  [[ ! -d "$backup" ]] && echo "✗ Mount backup flash at $backup" && return 1

  if [[ -d "$backup/secrets.git" ]]; then
    # update existing backup
    cd "$backup/secrets.git" || return 1
    git fetch "$primary/secrets.git" main:main --force
    echo "✓ Backup updated"
  else
    # create new backup
    git clone --bare "$primary/secrets.git" "$backup/secrets.git"
    echo "✓ Backup created"
  fi
}

secrets-make-backup-copy() {
  local ts=$(date +%Y%m%d-%H%M%S)
  local backed=0

  for mapper in /dev/mapper/secrets*; do
    [[ -e "$mapper" ]] || continue
    [[ "$mapper" =~ ^/dev/mapper/secrets[0-9]*$ ]] || continue

    local name="${mapper##*/}"
    local mnt="/mnt/${name}"

    if mountpoint -q "$mnt" 2>/dev/null; then
      git clone --mirror "$mnt/secrets.git" "$mnt/Backups/secrets-git/${ts}.git" 2>/dev/null && \
        echo "✓ ${name}: secrets.git backed up"

      cp -r ~/.secrets/passwords "$mnt/Backups/passwords/${ts}" 2>/dev/null && \
        echo "✓ ${name}: passwords backed up"

      ((backed++))
    fi
  done

  ((backed)) || echo "✗ No secrets drives mounted" >&2
}

function gpg-backup-keys() {
  local backup_dir="/mnt/secrets/Files/.gnupg"

  if ! findmnt -n -o FSTYPE /mnt/secrets | grep -q .; then
    echo "Error: /mnt/secrets not mounted"
    return 1
  fi

  if ! lsblk -o NAME,TYPE,MOUNTPOINT | grep -E "crypt.*(/mnt/secrets|$(findmnt -n -o SOURCE /mnt/secrets 2>/dev/null))" &>/dev/null; then
    echo "Error: /mnt/secrets doesn't appear to be on a LUKS-encrypted device"
    return 1
  fi

  mkdir -p "$backup_dir"

  cp -a ~/.gnupg/private-keys-v1.d "$backup_dir/"
  cp -a ~/.gnupg/openpgp-revocs.d "$backup_dir/"
  cp ~/.gnupg/pubring.kbx "$backup_dir/"
  cp ~/.gnupg/trustdb.gpg "$backup_dir/"

  echo "Backup complete: $backup_dir"
  ls -la "$backup_dir"
}

function gpg-restore-keys() {
  local backup_dir="/mnt/secrets/Files/.gnupg"

  if ! findmnt -n -o FSTYPE /mnt/secrets | grep -q .; then
    echo "Error: /mnt/secrets not mounted"
    return 1
  fi

  if ! lsblk -o NAME,TYPE,MOUNTPOINT | grep -E "crypt.*(/mnt/secrets|$(findmnt -n -o SOURCE /mnt/secrets 2>/dev/null))" &>/dev/null; then
    echo "Error: /mnt/secrets doesn't appear to be on a LUKS-encrypted device"
    return 1
  fi

  [[ -d "$backup_dir" ]] || {
    echo "No backup found at $backup_dir"
    return 1
  }

  mkdir -p ~/.gnupg
  chmod 700 ~/.gnupg

  cp -a "$backup_dir/private-keys-v1.d" ~/.gnupg/
  cp -a "$backup_dir/openpgp-revocs.d" ~/.gnupg/
  cp "$backup_dir/pubring.kbx" ~/.gnupg/
  cp "$backup_dir/trustdb.gpg" ~/.gnupg/

  echo "Restore complete"
  ls -la ~/.gnupg
}
