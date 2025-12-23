luks-list() {
  blkid -t TYPE=crypto_LUKS -o full
}

luks-mount() {
  local dev="${1:-/dev/sda}"

  sudo mkdir -p /mnt/secrets || return 1
  sudo cryptsetup open "$dev" secrets || return 1
  sudo mount /dev/mapper/secrets /mnt/secrets || return 1
  sudo chown -R "${USER}:users" /mnt/secrets || return 1
  echo "✓ Secrets unlocked at /mnt/secrets"
}

luks-close() {
  sudo umount -f /mnt/secrets 2>/dev/null || sudo umount -l /mnt/secrets
  sudo cryptsetup close secrets &&
    echo "✓ Secrets locked"
}
