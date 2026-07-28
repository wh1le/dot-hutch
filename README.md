# dot-hutch

NixOS + home-manager dotfiles. Flake-based, multi-host.

![Desktop](assets/i3-demo/i3-nvim.png)

## Daily driver

- **WM:** i3 + i3blocks
- **Launcher:** quickshell module
- **Passwords:** pass
- **Files:** yazi / nautilus (migrating to yazi)
- **Editor:** nvim
- **Terminal:** ghostty / tmux
- **Shell:** zsh
- **Colors:** pywal (system-wide theming)

Hyprland config is here too but likely broken after switching back to i3. It was fully completed but I wasn't able to run VR properly with screensharring as I do on x11

## Screenshots

WiFi and Bluetooth managed from TUIs (network names redacted):

![WiFi / Bluetooth](assets/i3-demo/i3-wifi-ble-management.png)

### Launcher (quickshell)

A custom launcher that goes past app-launching, it searches Nix options, Ruby gems, screenshoots, and clipboard history, and drives all my system actions. See [`home/.config/quickshell_launcher`](home/.config/quickshell_launcher).

|                                                                         |                                                      |
| ----------------------------------------------------------------------- | ---------------------------------------------------- |
| <img src="assets/i3-demo/launcher.png" width="360">                     | Main menu — power, wallpaper, screenshots, bookmarks |
| <img src="assets/i3-demo/launcher-app-search.png" width="360">          | App search                                           |
| <img src="assets/i3-demo/launcher-options.png" width="360">             | Extras — fonts, emoji, color picker, clipboard       |
| <img src="assets/i3-demo/launcher-nix-options-search.png" width="360">  | Search NixOS options inline                          |
| <img src="assets/i3-demo/launcher-gem-search.png" width="360">          | Search Ruby gems                                     |
| <img src="assets/i3-demo/launcher-screenshoot.png" width="360">         | Clipboard history with previews                      |
| <img src="assets/i3-demo/launcher-screenshoot-actions.png" width="360"> | Clipboard entry actions — copy / open / delete       |

## Hosts

| Host       | Type  | Config       |
| ---------- | ----- | ------------ |
| `homepc`   | NixOS | `.#homepc`   |
| `thinkpad` | NixOS | `.#thinkpad` |

## Build

```sh
# NixOS
sudo nixos-rebuild switch --flake .#thinkpad

# macOS
make mac              # or: ./scripts/deploy-on-mac
```

Secrets are managed with [sops-nix](https://github.com/Mic92/sops-nix) — encrypted, keys live outside the repo.

## Layout

```
flake.nix              inputs + host definitions
nixos/system/          host configs, hardware, packages
nixos/home/            home-manager (user dotfiles)
home/.config/          raw config files (i3, nvim, yazi, ...)
scripts/               deploy helpers
```
