secrets-mount() {
  local dev="${1:-/dev/sda}"
  sudo cryptsetup open "$dev" secrets 2>/dev/null || true
  sudo mount /dev/mapper/secrets /mnt/secrets 2>/dev/null || true
  sudo chown -R "${USER}:users" /mnt/secrets
  echo "✓ Secrets unlocked at /mnt/secrets"
}

secrets-close() {
  sudo umount -f /mnt/secrets 2>/dev/null || sudo umount -l /mnt/secrets
  sudo cryptsetup close secrets &&
    echo "✓ Secrets locked"
}
