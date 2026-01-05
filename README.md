# NixOS Configuration

A fully declarative, reproducible NixOS configuration featuring Hyprland, extensive automation, and hardware-optimized setups for workstations and laptops.

![Preview](https://github.com/nm1l0serd0v/dot-files/raw/master/logo.png)

## Highlights

- **Hyprland v0.52.0** with custom plugins (DarkWindow, Hyprspace, Hyprbars)
- **Dual-GPU Gaming Setup** - AMD RX 7600 for display, NVIDIA RTX 4090 for compute/VR
- **E-Ink Display Support** - Full integration with Dasung Paperlike
- **Dynamic Theming** - Pywal16 color generation synced across all applications
- **VR/XR Ready** - SteamVR, Monado OpenXR runtime, WiVRN for Wayland
- **Professional Secrets Management** - SOPS-Nix + Pass + GPG + Veracrypt
- **103+ Custom Scripts** - Extensive automation for daily workflows
- **Multi-Session Management** - Tmux sessionizer for dev/notes/music workflows

## Desktop Environment

### Wayland Compositor
- Hyprland with XWayland support
- Dynamic color theming via Pywal16
- Hypridle + Hyprlock for idle/lock screen
- Multi-monitor support via Kanshi
- Gaming optimizations (tearing, immediate mode)

### UI Components
- **Status Bar**: Waybar with custom modules (weather, VPN status, containers, mic activity)
- **Notifications**: SwayNC with custom themes
- **Greeter**: TUIgreet with custom time display
- **Wallpapers**: Swww for animated backgrounds
- **App Launcher**: Rofi/Wofi integration
- **Theme**: Darkman for automatic light/dark switching

### Hyprland Plugins
- `hyprspace` - Advanced workspace management
- `hypr-darkwindow` - Per-window dark mode detection
- `hyprbars` - Custom window decorations

## Software Stack

### Terminals & Shell

#### Kitty (Primary Terminal)
- **Iosevka Nerd Font Mono** with ligatures enabled
- **Performance Optimized**:
  - 1ms repaint/input delay for responsiveness
  - Monitor vsync enabled
  - Text composition strategy 3.0
  - Cursor blink disabled for CPU optimization
- **Scrollback**: 2000 lines with less pager integration
- **Mouse**: 5x scroll multiplier, instant hide
- **Remote Control**: Unix socket (`/tmp/kitty`) for scripting
  - Dynamic font size adjustment
  - Window/tab management via socket
  - Integration with launcher system
- **Wayland-native** with URL detection
- **Pywal Integration**: Dynamic color theming from `~/.cache/wal/colors-kitty.conf`
- **E-Ink Mode**: Optional high-contrast theme for e-ink displays
- **Keybindings**: Comprehensive window/tab/scrolling shortcuts

#### Unified Menu System (launch-dmenu)
A custom **Kitty + FZF** based launcher replacing traditional dmenu/rofi with 25+ integrated system management tools:

**Architecture:**
- **Kitty Remote Control** via Unix sockets for dynamic window sizing
- **FZF Integration** with custom styling, keybindings, and preview support
- **E-Ink Detection** - Auto-applies high-contrast themes
- **Smart Auto-closing** - Windows close after selection
- **Clipboard Integration** - Results copy directly to clipboard
- **Notification Feedback** - Desktop notifications for all actions

**Menu Options (25+):**
- **Applications** - Launch desktop apps via sway-launcher-desktop
- **Power Management** - Lock, logout, suspend, hibernate, reboot, shutdown
- **Passwords** - Pass integration with safe-mode (excludes private/)
- **2FA OTP** - TOTP codes with QR scanning support
- **Clipboard History** - Cliphist with preview window
- **Wallpaper Picker** - Image preview via kitty icat protocol
- **Wi-Fi Connect** - NetworkManager with live network scanning
- **Bluetooth** - Bluetui device manager
- **Audio Mixer** - Wiremix control
- **Display Profiles** - Kanshi profile switcher
- **NixOS Packages** - nix-search-tv with live documentation preview
- **NixOS Options** - System options search
- **Home-Manager Options** - User options search
- **Nix Switch** - System rebuild in dedicated tmux session
- **OpenVPN Connect** - VPN connection manager
- **Browser History** - Firefox SQLite history with 180s caching
- **Kill Process** - Process manager with sudo kill
- **Ruby Gems** - Remote gem search with info preview
- **MPD Playlists** - Create/manage music playlists
- **Pass OTP** - Scan QR codes for 2FA

**Smart Features:**
- **Dynamic Window Sizing** - Each tool resizes Kitty appropriately (100x200 to 700x400)
- **Live Previews** - Wallpapers show images, packages show docs, clipboard shows content
- **Performance Caching** - Browser history cached for 180 seconds
- **History Integration** - FZF remembers frequently used choices
- **Tmux Sessions** - Long-running tasks (nix switch) run in persistent sessions
- **Gum Spinners** - Visual feedback for network scanning operations

#### Shell Environment
- **Zsh** with autosuggestions, direnv, fzf
- **CLI Tools**: btop, eza, bat, ripgrep, jq, lazygit, yazi

### Editors & Development
- **Neovim** (unstable) with extensive Lua configuration
- **LSP Support**: Lua, Bash, TypeScript, Python, Rust, Nix, YAML, JSON
- **Formatters**: Black, Prettier, Stylua, Shfmt, Nixfmt, Rustfmt
- **Languages**: Node.js 24, Python 3, Ruby 3.4, Rust

### Browsers

#### Firefox (Primary)
- **Wayland-native** rendering with hardware acceleration
- **Pywalfox** integration for dynamic color theming
- **Profile Management**:
  - Default profile with Searx integration
  - Work profile with separate desktop launcher
- **Privacy & Performance**:
  - Session restore on demand (lazy tab loading)
  - Pinned tabs lazy loading
  - Auto-unload inactive tabs after 10 minutes
- **Default Search**: Local Searx instance (localhost:8882)
- **Tridactyl** native messaging for Vim-style navigation

#### Qutebrowser (Power User)
- **Python-Configurable** browser with modular architecture
- **Privacy Features**:
  - Do Not Track enabled
  - Third-party cookie blocking
  - Custom IceCat-based User-Agent
  - Geolocation disabled
  - Notifications blocked
  - Clipboard access restricted
- **Ad Blocking**:
  - Built-in Adblock engine
  - uBlock Origin filter lists (2020-2025)
  - Privacy, annoyances, and badware filters
  - Cookie consent blocker
- **Search Engines** with shortcuts:
  - `!g` Google, `!d` DuckDuckGo (default)
  - `!gh` GitHub, `!yt` YouTube
  - `!np` NixOS packages, `!no` NixOS options
  - `!aw` Arch Wiki, `!cl` Claude AI
- **UI Customization**:
  - Tabs on right side with custom sizing
  - Pinned tabs shrink to index only
  - Session auto-save with lazy restore
  - 90% default zoom
  - Smooth scrolling
- **Userscripts**:
  - MPV video player integration
  - qute-pass (password manager integration)
  - YouTube ad blocking via Greasemonkey
- **Theming**:
  - Dynamic color generation via Pywal
  - E-ink high contrast mode support
  - Dark Reader support (disabled by default)
- **Hardware Acceleration** (ThinkPad):
  - GPU rasterization
  - Native GPU memory buffers
  - Accelerated 2D canvas
  - Zero-copy rendering

### Media & Entertainment
- **Music**: MPD + MPRIS, Cava visualizer, Rmpc client
- **Video**: MPV, VLC, yt-dlp, Yewtube
- **Images**: Zathura (PDF), IMV, NSXIV, ImageMagick

### Gaming & VR
- **Steam** with Proton-GE-Bin
- **SteamVR** with Monado runtime
- **VR Tools**: WiVRN, WLX-Overlay-S
- **Gamescope** session support
- **GPU Offloading** to NVIDIA 4090

## Security & Privacy

### Encryption & Credentials
- **SOPS-Nix** - Age-based secrets management
- **Pass** - Password manager with OTP/import extensions
- **GPG** - Key management with pinentry
- **Veracrypt** - Encrypted volume support
- **Git-crypt** - Encrypted git repositories

### Network Security
- **Firewall** - NixOS firewall with custom rules
- **OpenVPN** - Passwordless sudo execution
- **SSH** - Custom port (1234), key-only auth
- **Pi-hole** - Local DNS filtering
- **ClamAV** - Weekly malware scanning

## System Administration

### Virtualization & Containers
- **QEMU/KVM** with virt-manager, TPM 2.0, OVMF
- **Docker** with NVIDIA container support
- **Podman** rootless with TUI management
- **Distrobox** for containerized environments

### Databases & Services
- **PostgreSQL 16** - Local dev/test databases
- **Redis** - In-memory data store
- **SQLite** - Lightweight database support

### Monitoring & Tools
- **System**: Btop, Htop, Nvtop, Conky
- **Systemd**: systemctl-tui, lazyjournal
- **Network**: Snitch (network monitor)

### Automation
- **Cron Jobs**:
  - Password store sync (every 5 minutes)
  - Clipboard wipe (every 5 days)
  - Trash cleanup (every 5 days)
- **Auto-upgrade** via Nix
- **Git watchers** for auto-commit/push

## Hardware Support

### Homepc (Desktop)
- Intel CPU with microcode updates
- AMD Radeon RX 7600 (display)
- NVIDIA RTX 4090 (compute/gaming)
- NZXT Kraken AIO cooler
- UEFI/systemd-boot
- Multi-monitor with Kanshi profiles

### Thinkpad (Laptop)
- AMD/Intel CPU support
- Power management (balanced/powersave modes)
- TLP/auto-cpufreq thermal optimization
- Backlight control
- Hardware-specific audio/graphics
- Disko declarative disk partitioning

### Specialized Hardware
- **E-Ink**: Dasung Paperlike with custom scripts
- **Bluetooth**: Device management and pairing
- **Printers**: CUPS support
- **USB**: Device management

## Custom Scripts (103+)

### Power & Display
`sunset`, `caffeine`, `set-keyboard-backlight`, `set-monitor-brightness`, `power-management`

### Audio & Music
`audio`, `rmpc`, MPD playlist management, audio profile switching

### Wayland & Desktop
`navigate-hyprland`, `swaync`, `apply-wallpaper`, `apply-colors-globally`, `picker-menu`, `set-ink`

### Networking
`openvpn`, `wifi-connect`, `bluetooth`, VPN management

### Development
`nix-search-packages`, `nix-switch`, `tmux-sessionizer`, `local-session`, `clipboard-history`

### Waybar Modules
Weather forecast, language indicator, VPN status, container status, microphone activity, date/time

## File Organization

```
.
├── flake.nix              # Main flake configuration
├── home/                  # Home-manager dotfiles
│   └── .config/          # 40+ managed application configs
├── nixos/
│   ├── hosts/            # Host-specific configurations
│   │   ├── homepc/
│   │   └── thinkpad/
│   └── home/
│       ├── modules/      # Home-manager modules
│       └── users/        # User configurations
└── scripts/              # Custom automation scripts
```

## Tech Stack

**Core**: NixOS 25.11 (stable + unstable overlay)
**Display**: Hyprland 0.52.0, Waybar, SwayNC
**Terminal**: Kitty, Zsh, Neovim
**Secrets**: SOPS-Nix, Age encryption
**Boot**: Lanzaboote (Secure Boot), systemd-boot
**Containers**: Docker, Podman, QEMU/KVM
**Theming**: Pywal16, Darkman, GTK/Qt theming

## Flake Inputs

- `nixpkgs` (25.11 stable)
- `nixpkgs-unstable` (bleeding-edge packages)
- `home-manager` (dotfile management)
- `sops-nix` (secrets management)
- `lanzaboote` (Secure Boot with UEFI)
- `disko` (declarative partitioning)
- `hyprland` + plugins ecosystem
- `yazi`, `h-m-m` (custom builds)

## Features for Enthusiasts

- **Reproducibility**: Flake-based with pinned inputs
- **Modularity**: Separated hardware/software/security configs
- **Automation**: Extensive scripting for common workflows
- **Multi-host**: Easy deployment to desktop/laptop/SteamDeck
- **Privacy-focused**: Local services, no telemetry
- **Bleeding-edge**: Unstable overlay for latest software
- **Hardware optimization**: Per-device tuning and profiles
- **E-Ink support**: Full grayscale/BW mode pipeline
- **Professional secrets**: Multi-layer encryption strategy
- **Gaming-ready**: VR, Steam, GPU offloading, performance tuning

## License

MIT (dotfiles and scripts)
Individual software packages retain their original licenses.

---

**Note**: Setup documentation coming soon. This configuration is designed for advanced users familiar with NixOS and Flakes.
