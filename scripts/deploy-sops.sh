#!/usr/bin/env bash
set -euo pipefail

sudo mkdir -p /var/lib/sops-nix/secrets
sudo cp /home/wh1le/.secrets/sops/nix.yaml /var/lib/sops-nix/secrets/nix.yaml
sudo cp /home/wh1le/.secrets/sops/age/keys.txt /var/lib/sops-nix/key.txt
sudo chown -R root:root /var/lib/sops-nix
sudo chmod 700 /var/lib/sops-nix
sudo chmod 600 /var/lib/sops-nix/key.txt /var/lib/sops-nix/secrets/nix.yaml
