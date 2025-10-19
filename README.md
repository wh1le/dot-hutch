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
- `flake.lock` — Pin for reproducibility.
- `hosts/` - NixOS modules for a Hyprland-based desktop VM.
- `home/` - Home Manager configuration
- `scripts/` — Auxiliary scripts and an alternate module, will be removed soon in favour of nix-home
  - `scripts/setup-dotfiles.sh` — First-boot dotfiles bootstrap.
- `.gitignore` — Ignores build symlink `result` and `*.qcow2` images.

## Prerequisites

- Nix installed with flakes enabled.
- Linux host capable of running QEMU/KVM.
- Network access for first-boot dotfiles bootstrap (optional but expected by the provided modules).
