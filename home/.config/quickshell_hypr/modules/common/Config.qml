pragma Singleton
pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root
    property string filePath: Directories.shellConfigPath
    property alias options: configOptionsJsonAdapter
    property bool ready: false
    property int readWriteDelay: 50

    function setNestedValue(nestedKey, value) {
        let keys = nestedKey.split(".");
        let obj = root.options;
        let parents = [obj];

        for (let i = 0; i < keys.length - 1; ++i) {
            if (!obj[keys[i]] || typeof obj[keys[i]] !== "object") {
                obj[keys[i]] = {};
            }
            obj = obj[keys[i]];
            parents.push(obj);
        }

        let convertedValue = value;
        if (typeof value === "string") {
            let trimmed = value.trim();
            if (trimmed === "true" || trimmed === "false" || !isNaN(Number(trimmed))) {
                try {
                    convertedValue = JSON.parse(trimmed);
                } catch (e) {
                    convertedValue = value;
                }
            }
        }

        obj[keys[keys.length - 1]] = convertedValue;
    }

    // --- Testable pure JS functions ---
    function _convertValue(value) {
        if (typeof value === "string") {
            let trimmed = value.trim();
            if (trimmed === "true" || trimmed === "false" || !isNaN(Number(trimmed))) {
                try {
                    return JSON.parse(trimmed);
                } catch (e) {
                    return value;
                }
            }
        }
        return value;
    }

    function _setNestedOnObject(obj, nestedKey, value) {
        let keys = nestedKey.split(".");
        let current = obj;
        for (let i = 0; i < keys.length - 1; ++i) {
            if (!current[keys[i]] || typeof current[keys[i]] !== "object") {
                current[keys[i]] = {};
            }
            current = current[keys[i]];
        }
        current[keys[keys.length - 1]] = root._convertValue(value);
        return obj;
    }

    Timer {
        id: fileReloadTimer
        interval: root.readWriteDelay
        repeat: false
        onTriggered: configFileView.reload()
    }

    Timer {
        id: fileWriteTimer
        interval: root.readWriteDelay
        repeat: false
        onTriggered: configFileView.writeAdapter()
    }

    FileView {
        id: configFileView
        path: root.filePath
        watchChanges: true
        onFileChanged: fileReloadTimer.restart()
        onAdapterUpdated: fileWriteTimer.restart()
        onLoaded: root.ready = true
        onLoadFailed: error => {
            if (error == FileViewError.FileNotFound) {
                writeAdapter();
            }
        }

        JsonAdapter {
            id: configOptionsJsonAdapter

            property JsonObject time: JsonObject {
                property string format: "HH:mm"
                property string shortDateFormat: "dd/MM"
                property string dateWithYearFormat: "dd/MM/yyyy"
                property string dateFormat: "ddd, dd/MM"
                property bool secondPrecision: false
            }

            property JsonObject appearance: JsonObject {
                property JsonObject fonts: JsonObject {
                    property string main: "Google Sans Flex"
                    property string numbers: "Google Sans Flex"
                    property string title: "Google Sans Flex"
                    property string monospace: "JetBrains Mono NF"
                }
            }

            property JsonObject audio: JsonObject {
                property JsonObject protection: JsonObject {
                    property bool enable: false
                    property real maxAllowedIncrease: 10
                    property real maxAllowed: 99
                }
            }

            property JsonObject battery: JsonObject {
                property int low: 20
                property int critical: 5
                property int full: 101
                property bool automaticSuspend: true
                property int suspend: 3
            }

            property JsonObject light: JsonObject {
                property JsonObject night: JsonObject {
                    property bool automatic: true
                    property string from: "19:00"
                    property string to: "06:30"
                    property int colorTemperature: 5000
                }
            }

            property JsonObject media: JsonObject {
                property bool filterDuplicatePlayers: true
            }

            property JsonObject notifications: JsonObject {
                property int timeout: 7000
            }

            property JsonObject tray: JsonObject {
                property bool filterPassive: true
                property bool invertPinnedItems: true
                property list<var> pinnedItems: []
                property bool showItemId: false
                property list<var> trayApps: []
                property list<var> systemdServices: []
            }

            property JsonObject calendar: JsonObject {
                property string locale: "en-GB"
            }

            property JsonObject bar: JsonObject {
                property JsonObject weather: JsonObject {
                    property bool enable: true
                    property int fetchInterval: 30
                }
            }

            // Launcher & menu mode settings
            property JsonObject launcher: JsonObject {
                property int maxItems: 8
                property int itemHeight: 40
                property int itemWidth: 500
                property string fontFamily: "Hack-ZeroSlash"
                property int fontSize: 12
                property string terminal: "kitty"
                // Default terminal dimensions for menu mode scripts
                property int termFontSize: 13
                property int termWidth: 800
                property int termHeight: 500
            }

            property JsonObject wallpaper: JsonObject {
                property string baseDir: Quickshell.env("HOME") + "/Code/dot-wallpapers"
                property string applyScript: Quickshell.env("HOME") + "/.local/bin/public/wallpaper/apply-wallpaper"
            }

            // Menu mode entries
            // icon:     nerd font glyph
            // label:    display name
            // option:   script name under ~/.config/fzm/options/
            // script:   raw shell command (used if no option)
            // args:     extra arguments for option scripts
            // w/h/fs:   terminal width/height/fontSize overrides
            property list<var> menuItems: [
                // ── browsing ──
                { icon: "󰖟",  label: "Browser Bookmarks",    source: "~/.config/quickshell/scripts/bookmarks.sh list", handler: "~/.config/quickshell/scripts/bookmarks.sh", previewFormat: "bookmark", cacheTTL: 0 },
                { icon: "󰖟", label: "Browser History",      source: "~/.config/quickshell/scripts/history.sh list", handler: "~/.config/quickshell/scripts/history.sh", previewFormat: "bookmark", cacheTTL: 0 },
                { icon: "󰋩", label: "Screenshots",          source: "~/.config/quickshell/scripts/screenshots.sh list", handler: "~/.config/quickshell/scripts/screenshots.sh", previewFormat: "image", cacheTTL: 0, maxResults: 0 },
                { icon: "󰕧", label: "Search Youtube",       script: "gophertube" },
                { icon: "󰚑", label: "Kill Process",         source: "~/.config/quickshell/scripts/kill-process.sh list", handler: "~/.config/quickshell/scripts/kill-process.sh", cacheTTL: 0, maxResults: 0 },
                { icon: "󰣌", label: "Wallpaper",            action: "wallpaper-picker" },

                // ── system ──
                { icon: "", label: "Systemd",              source: "~/.config/quickshell/scripts/systemd.sh list", handler: "~/.config/quickshell/scripts/systemd.sh", cacheTTL: 0, maxResults: 0 },
                { icon: "󰐥", label: "Power Management",     option: "power-management",     w: 350, h: 300 },
                { icon: "", label: "Audio",                script: "wiremix" },

                // ── network ──
                { icon: "", label: "Network",              script: "wifitui" },
                { icon: "󱘖", label: "SSH",                  option: "ssh-connect",          w: 400, h: 500, fs: 12 },
                { icon: "󰌾", label: "WireGuard VPN",        option: "wg-manage",            w: 350, h: 300, fs: 11 },
                { icon: "󱠾", label: "OpenVPN Connect",       option: "openvpn-connect",      w: 350, h: 300 },
                { icon: "󰤨", label: "Wi-Fi connect",         option: "wifi-connect" },
                { icon: "", label: "Bluetooth",            script: "bluetui" },

                // ── nix ──
                { icon: "", label: "(Nix) Packages",       source: "NIX_INDEX=nixpkgs ~/.config/quickshell/scripts/nix-packages.sh list", handler: "NIX_INDEX=nixpkgs ~/.config/quickshell/scripts/nix-packages.sh", preview: "NIX_INDEX=nixpkgs ~/.config/quickshell/scripts/nix-packages.sh preview {}", previewFormat: "nix-json", sourceLabel: "25.11", unstable: true },
                { icon: "", label: "(Nix) Options",        source: "NIX_INDEX=nixos ~/.config/quickshell/scripts/nix-packages.sh list", handler: "NIX_INDEX=nixos ~/.config/quickshell/scripts/nix-packages.sh", preview: "NIX_INDEX=nixos ~/.config/quickshell/scripts/nix-packages.sh preview {}", previewFormat: "nix-json", sourceLabel: "25.11", unstable: true },
                { icon: "", label: "(Nix) Home Options",   source: "NIX_INDEX=home-manager ~/.config/quickshell/scripts/nix-packages.sh list", handler: "NIX_INDEX=home-manager ~/.config/quickshell/scripts/nix-packages.sh", preview: "NIX_INDEX=home-manager ~/.config/quickshell/scripts/nix-packages.sh preview {}", previewFormat: "nix-json", sourceLabel: "25.11", unstable: true },
                { icon: "", label: "(Nix) Switch",         option: "nix-switch" },

                // ── passwords & security ──
                { icon: "", label: "Passwords",            source: "~/.config/quickshell/scripts/passwords.sh list", handler: "~/.config/quickshell/scripts/passwords.sh", cacheTTL: 0 },
                { icon: "", label: "Passwords (All)",      source: "~/.config/quickshell/scripts/passwords-all.sh list", handler: "~/.config/quickshell/scripts/passwords-all.sh", cacheTTL: 0 },
                { icon: "", label: "2FA OTP",              source: "~/.config/quickshell/scripts/otp.sh list", handler: "~/.config/quickshell/scripts/otp.sh", cacheTTL: 0 },
                { icon: "", label: "Scan OTP",             option: "pass-scan-otp",        w: 350, h: 300 },

                // ── quick copy ──
                { icon: "󰅍", label: "Quick Copy",           source: "~/.config/quickshell/scripts/quick-copy.sh list", handler: "~/.config/quickshell/scripts/quick-copy.sh", cacheTTL: 0 },

                // ── tools ──
                { icon: "󰣆", label: "Applications",         option: "applications",         w: 350, h: 300 },
                { icon: "", label: "Clipboard",            source: "cliphist list", preview: "echo {} | cliphist decode", previewFormat: "clipboard", cacheTTL: 0, selectAction: "clipboard" },
                { icon: "", label: "Color Picker",         script: "hyprpicker | wl-copy", w: 350, h: 300 },
                { icon: "󰞅", label: "Emoji Picker",         option: "emoji-picker",         w: 400, h: 500, fs: 12 },
                { icon: "", label: "Nerd Font Picker",     option: "nerd-icon-picker",      w: 400, h: 500 },
                { icon: "", label: "Fonts",                option: "font-preview" },
                { icon: "", label: "Manuals",              option: "man-browser" },
                { icon: "", label: "Aur search",           option: "aur-search" },
                { icon: "", label: "Ruby Gems",            source: "~/.config/quickshell/scripts/ruby-gems.rb list", handler: "~/.config/quickshell/scripts/ruby-gems.rb", preview: "~/.config/quickshell/scripts/ruby-gems.rb preview {}", cacheTTL: 0 },
                { icon: "󰍹", label: "Display Profiles | Kanshi",     source: "~/.config/quickshell/scripts/kanshi-profiles.sh list", handler: "~/.config/quickshell/scripts/kanshi-profiles.sh", cacheTTL: 0 },

                // ── mpd ──
                { icon: "󰲸", label: "(MPD) Create Playlist",   script: "$HOME/.local/bin/public/mpd-create-new-playlist",              w: 350, h: 300 },
                { icon: "", label: "(MPD) Add to Playlist",    script: "$HOME/.local/bin/public/mpd-add-current-song-to-playlist",    w: 350, h: 300 }
            ]
        }
    }
}
