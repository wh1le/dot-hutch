# wh1le NixOS (Hyprland) — Flake Repo

## TODO:

This repository contains a Nix flake to build and launch a NixOS with a Hyprland desktop environment

I am new to NixOS and want to see if this system will suit me as a daily driver. So this is by no means a workable configuration.

## Overview

- Pinned to `nixos-25.05` via flake inputs.
- Optional Hyprland desktop configuration modules (not wired by default).
- First-boot service to clone and link personal dotfiles.

## Repository Layout

- `flake.nix` — Flake definition and `nixosConfigurations` entry.
- `hosts/` - hosts golder
- `home/` - Home Manager configuration
- `scripts/` — Auxiliary scripts and an alternate module, will be removed soon in favour of nix-home

Current configuration includes:

- Rasbery Pi config for PiHole
- Hyprland Setup for pc with Nvidia 4090

## Build image for Rasbery PI3 with Pi-Hole

```bash
# generate secrets with sops
sops secrets/default.yaml

# Map you Router IP address

# build image
nix build .#nixosConfigurations.khole.config.system.build.sdImage

# go to release folder
cd result/sd-image/

# write to drive
sudo dd if=./image.img of=/dev/sdX bs=4M status=progress conv=fsync
```

## Prerequisites

- Nix installed with flakes enabled.
- Linux host capable of running QEMU/KVM.
- Network access for first-boot dotfiles bootstrap (optional but expected by the provided modules).
