# wh1le NixOS VM (Hyprland) — Flake Repo

# TODO:

- [ ] Use Nix Home Env for dotfiles delivery?

This repository contains a Nix flake to build and launch a NixOS virtual machine with a Hyprland desktop environment, plus helper modules and scripts to bootstrap user dotfiles. It is designed for quick iteration in a QEMU VM and reproducible setups pinned to a specific nixpkgs release.

I am new to NixOS and want to see if this system will suit me as a daily driver. So this is by no means a workable configuration.

## Overview

- Pinned to `nixos-25.05` via flake inputs.
- Builds a QEMU-based NixOS VM (`qemu-vm` module).
- Optional Hyprland desktop configuration modules (not wired by default).
- First-boot service to clone and link personal dotfiles.
- Make targets to build and launch the VM.

## Repository Layout

- `flake.nix` — Flake definition and `nixosConfigurations` entry.
- `flake.lock` — Pin for reproducibility.
- `Makefile` — Shortcuts to build and run the VM.
- `configurations/` — NixOS modules for a Hyprland-based desktop VM.
- `scripts/` — Auxiliary scripts and an alternate module.
  - `scripts/setup-dotfiles.sh` — First-boot dotfiles bootstrap.
- `.gitignore` — Ignores build symlink `result` and `*.qcow2` images.

Notes:

- You may see a local VM disk image like `wh1le-vm-debug.qcow2` present in your working directory; it is ignored by Git.

## Prerequisites

- Nix installed with flakes enabled.
- Linux host capable of running QEMU/KVM.
- Network access for first-boot dotfiles bootstrap (optional but expected by the provided modules).

## Quick Start

Build the VM using the flake target:

```
nix build .#nixosConfigurations.hyprland-vm-desktop.config.system.build.vm
```

Or via the Makefile:

```
make build
```

Launch the VM. The run script is placed under `result/bin/` and is named after the VM; the Makefile uses:

```
make launch-debug-vm
```

which expands to:

```
result/bin/run-wh1le-vm-debug-vm -m 16384 -smp 6
```

Tip: If you modify the hostname or change modules, the run script name may differ. Inspect `result/bin/` after a build.

## Flake Definition

The default flake defines a VM configuration using the upstream `qemu-vm` module and enables unfree packages:

To use the Hyprland configuration from this repo, include the module (see next section).

## Dotfiles Bootstrap

Both Hyprland modules define a one-shot systemd service `dotfiles-setup` that runs once at first boot. It:

- Clones `https://github.com/wh1le/dot-files.git` (branch `linux`) into `/home/wh1le/dot/files`.
- Switches the remote to SSH `git@github.com:wh1le/dot-files.git`.
- Runs `make link_common` and `make link_linux_hypr` to link configs.
- Creates `/home/wh1le/.dotfiles-setup-done` as a completion marker.

Script source:

- `scripts/setup-dotfiles.sh`

Requirements:

- Network access on first boot.
- The `wh1le` user defined by the module.

## Credentials and Security

- Default user: `wh1le`
- Default password: `1234`

Change the initial password and review enabled services before using beyond local VM testing.

## Customization

- Hostname, timezone, locale: edit the chosen module under `configurations/` or `scripts/`.
- VM resources: adjust `virtualisation.memorySize` and `virtualisation.cores`.
- GPU: the modules use virtio GPU; adapt QEMU options if needed.
- Packages: modify `environment.systemPackages`.
- Keyboard layout: update `services.xserver.xkb.layout` and `options`.

## Usage Tips

- Rebuild after changes:
  - `nix build .#nixosConfigurations.hyprland-vm-desktop.config.system.build.vm`
- Launch script location:
  - Look under `result/bin/` for `run-*-vm` (name depends on configuration/hostname).
- Makefile helpers:
  - `make build`
  - `make launch-debug-vm`

## Troubleshooting

- No run script found: Ensure the build finished and check `result/bin/`.
- Wrong run script name: It is derived from the VM name; inspect `result/bin/`.
- GUI issues inside VM: Confirm virtio GPU is used; try `-display sdl` with QEMU if needed (comment in Makefile shows the flag).
- Dotfiles not applied: Check `/home/wh1le/.dotfiles-setup-done` and `journalctl -u dotfiles-setup` inside the VM.

## Notes

- Unfree packages are enabled (for items like `zoom-us`). Review and adjust according to your needs.
- The `configurations/configuration-backup-non-workable.nix` is kept for reference; prefer `configurations/hyprland.nix` or `scripts/configuration-hypr.nix`.

---

If you want, I can wire `configurations/hyprland.nix` into `flake.nix` and validate the build/run flow.
