```bash
# List recorded boots: 0 = current, -1 = previous.

sudo journalctl --list-boots --no-pager

# Inspect current boot's LUKS unlock service.

sudo journalctl -b -u systemd-cryptsetup@encrypted.service \
 --no-pager -o short-monotonic

# Inspect previous boot's LUKS unlock service.

sudo journalctl -b -1 -u systemd-cryptsetup@encrypted.service \
 --no-pager -o short-monotonic

# Find unlock errors and root-device timeouts in the previous boot.

sudo journalctl -b -1 --no-pager -o short-monotonic \
 --grep='crypt|luks|tpm|decrypt|passphrase|keyslot|Timed out|Dependency failed' \
 --case-sensitive=no

# Inspect previous boot's graphics initialization and NVIDIA messages.

sudo journalctl -b -1 -k --no-pager -o short-monotonic \
 --grep='nvidia|NVRM|nouveau|drm|simpledrm|fbcon|Xid' \
 --case-sensitive=no

# Read the full previous boot without filtering away context.

sudo journalctl -b -1 --no-pager -o short-monotonic

# Apply NixOS configuration changes, including the next boot's initrd.

sudo nixos-rebuild switch --flake .#homepc
```
