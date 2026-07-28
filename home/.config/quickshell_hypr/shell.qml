//@ pragma UseQApplication
//@ pragma Env QT_QUICK_CONTROLS_STYLE=Basic
//@ pragma Env QT_QUICK_FLICKABLE_WHEEL_DECELERATION=10000

import "modules/common"
import "modules/minimize-tray"
import "services"
import "launcher/services"

import QtQuick
import Quickshell
import Quickshell.Io
ShellRoot {
    id: root

    Component.onCompleted: {
        loginSound.running = true;
        MaterialThemeLoader.reapplyTheme();
        // Force singletons to load eagerly
        void MenuMode.results;
        void FzfSource.results;
        // Sync wallpaper thumbnails in background
        let syncScript = Qt.resolvedUrl("wallpaper/sync_thumbs.sh").toString();
        if (syncScript.startsWith("file://")) syncScript = decodeURIComponent(syncScript.substring(7));
        Quickshell.execDetached(["bash", syncScript, Config.options.wallpaper.baseDir]);
    }

    Process {
        id: loginSound
        command: ["sh", "-c", "if [ $(cut -d. -f1 /proc/uptime) -lt 30 ]; then paplay \"${SOUND_THEME_PATH:-/run/current-system/sw/share/sounds/ocean/stereo}/theme-demo.oga\" & fi"]
    }

    IpcHandler {
        target: "launcher"

        function toggle(): void {
            GlobalStates.menuModeOpen = false;
            GlobalStates.appLauncherOpen = !GlobalStates.appLauncherOpen;
        }
    }

    IpcHandler {
        target: "menu"

        function toggle(): void {
            GlobalStates.appLauncherOpen = false;
            GlobalStates.menuModeOpen = !GlobalStates.menuModeOpen;
        }
    }

    IpcHandler {
        target: "wallpaper"

        function toggle(): void {
            GlobalStates.appLauncherOpen = false;
            GlobalStates.menuModeOpen = false;
            GlobalStates.wallpaperPickerOpen = !GlobalStates.wallpaperPickerOpen;
        }
    }

    IpcHandler {
        target: "quick-copy"

        function toggle(): void {
            GlobalStates.appLauncherOpen = false;
            GlobalStates.menuModeOpen = false;
            if (GlobalStates.fzfPanelOpen) {
                GlobalStates.fzfPanelOpen = false;
            } else {
                let item = MenuMode.labelMap["Quick Copy"];
                if (item) {
                    GlobalStates.fzfPanelOpen = true;
                    FzfSource.activate(item);
                }
            }
        }
    }

    IpcHandler {
        target: "pinentry"

        function request(data: string): void {
            let parts = data.split("\n");
            PinEntry.request(parts[0] || "", parts[1] || "", parts[2] || "", parts[3] || "");
        }
    }

    IpcHandler {
        target: "bar"

        // Reveal/hide bar during fullscreen without keeping a surface over the
        // fullscreen window (no scanout block / VRR flicker).
        function toggleReveal(): void {
            GlobalStates.barRevealedInFullscreen = !GlobalStates.barRevealedInFullscreen;
        }
    }

    IpcHandler {
        target: "minimize-tray"

        function hide(): void {
            MinimizeTrayService.hide();
        }

        function smartClose(): void {
            MinimizeTrayService.smartClose();
        }
    }

    ShellWindow {}
}
