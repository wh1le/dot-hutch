luks-list() {
  echo "=== LUKS Devices ==="
  echo ""

  sudo blkid -t TYPE=crypto_LUKS -o device 2>/dev/null | while read dev; do

    size=$(lsblk -no SIZE "$dev" 2>/dev/null | head -1)
    label=$(sudo blkid -s LABEL -o value "$dev" 2>/dev/null)
    mapper=$(lsblk -lno NAME,TYPE "$dev" 2>/dev/null | awk '$2=="crypt" {print $1}')

    if [[ -n "$mapper" && -e "/dev/mapper/$mapper" ]]; then
      mount=$(findmnt -no TARGET "/dev/mapper/$mapper" 2>/dev/null)
      printf "%-12s %6s  %-12s  unlocked → /dev/mapper/%s %s\n" "$dev" "$size" "${label:--}" "$mapper" "${mount:+@ $mount}"
    else
      printf "%-12s %6s  %-12s  locked\n" "$dev" "$size" "${label:--}"
    fi
  done
}

# TODO: remove after testing
# secrets-mount() {
#   local dev="${1:-/dev/sda}"
#
#   sudo mkdir -p /mnt/secrets || return 1
#   sudo cryptsetup open "$dev" secrets || return 1
#   sudo mount /dev/mapper/secrets /mnt/secrets || return 1
#   sudo chown -R "${USER}:users" /mnt/secrets || return 1
#   echo "✓ Secrets unlocked at /mnt/secrets"
# }

# secrets-verify() {
#   local a="${1:-/mnt/secrets}"
#   local b="${2:-/mnt/secrets2}"
#
#   local sum_a=$(find "$a" -type f -exec md5sum {} + | sed "s|$a||g" | sort)
#   local sum_b=$(find "$b" -type f -exec md5sum {} + | sed "s|$b||g" | sort)
#
#   [[ "$sum_a" == "$sum_b" ]]
# }

secrets-verify() {
  local a="${1:-/mnt/secrets}"
  local b="${2:-/mnt/secrets2}"

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

secrets-mount() {
  local dev="${1:-/dev/sda}"
  local index="$2"
  local name="secrets${index}"
  local mnt="/mnt/${name}"

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

# secrets-close() {
#   sudo umount -f /mnt/secrets 2>/dev/null || sudo umount -l /mnt/secrets
#   sync
#   sudo cryptsetup close secrets &&
#     echo "✓ Secrets locked"
# }

secrets-sync() {
  local secrets_dir="$HOME/.secrets"
  local remote_dir="/mnt/secrets/secrets.git"

  [[ ! -d "$remote_dir" ]] && echo "✗ Mount flash first" && return 1
  [[ ! -d "$secrets_dir/.git" ]] && echo "✗ No repo at $secrets_dir" && return 1

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

