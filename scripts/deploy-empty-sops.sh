#!/usr/bin/env bash

if ! command -v age-keygen &>/dev/null; then
  nix shell nixpkgs#age nixpkgs#sops --command bash -c "$(declare -f generate_sops); generate_sops"
  return
fi

sudo mkdir -p /mnt/var/lib/sops-nix/secrets

sudo age-keygen -o /mnt/var/lib/sops-nix/key.txt
PUBLIC_KEY=$(sudo grep -oP "public key: \K.*" /mnt/var/lib/sops-nix/key.txt)

sudo tee /mnt/var/lib/sops-nix/secrets/.sops.yaml >/dev/null <<EOF
creation_rules:
  - path_regex: .*
    key_groups:
      - age:
          - $PUBLIC_KEY
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

SOPS_AGE_KEY_FILE=/mnt/var/lib/sops-nix/key.txt \
  sudo -E sops --encrypt --age "$PUBLIC_KEY" /tmp/sops_template.yaml |
  sudo tee /mnt/var/lib/sops-nix/secrets/nix.yaml >/dev/null

rm /tmp/sops_template.yaml

sudo chown -R root:root /mnt/var/lib/sops-nix
sudo chmod 700 /mnt/var/lib/sops-nix /mnt/var/lib/sops-nix/secrets
sudo chmod 600 /mnt/var/lib/sops-nix/key.txt /mnt/var/lib/sops-nix/secrets/nix.yaml

echo "SOPS setup complete."
echo "Public key: $PUBLIC_KEY"
echo "Edit secrets: sudo SOPS_AGE_KEY_FILE=/var/lib/sops-nix/key.txt sops /var/lib/sops-nix/secrets/nix.yaml"
