alias gpg-keys="gpg --list-keys --keyid-format=long"

function gpg-restart() {
  gpgconf --kill gpg-agent
  gpg-connect-agent /bye
  echo "GPG agent restarted"
}

function gpg-backup-keys() {
  local backup_dir="/mnt/secrets/.secrets/.gnupg"

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
  local backup_dir="/mnt/secrets/.secrets/.gnupg"

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
