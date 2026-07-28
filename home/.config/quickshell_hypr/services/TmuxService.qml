pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import Quickshell.Wayland

Singleton {
    id: root

    // Public API
    property bool available: false
    property string sessionName: ""
    property var windows: []
    property int activeWindowIndex: -1
    property var allClients: []
    property var allWindows: []
    property var allPanes: ({})
    property int revision: 0

    // Use Wayland toplevel for active window detection
    readonly property Toplevel activeToplevel: ToplevelManager.activeToplevel
    readonly property string activeAppId: activeToplevel?.appId ?? ""
    readonly property string activeTitle: activeToplevel?.title ?? ""

    // Debounced kitty detection — waits for appId+title to settle
    property bool kittyFocused: false
    property int kittyPid: -1

    onActiveAppIdChanged: focusSettleTimer.restart()
    onActiveTitleChanged: focusSettleTimer.restart()

    readonly property string tmuxTitlePrefix: "tmux: kitty - "

    Timer {
        id: focusSettleTimer
        interval: 30
        onTriggered: {
            var appId = root.activeAppId;
            var title = root.activeTitle;
            if (appId === "") return;

            if (appId !== "kitty") {
                root.kittyFocused = false;
                root.kittyPid = -1;
                root.clearTmuxState();
                return;
            }

            root.kittyFocused = true;

            // Find PID from Hyprland (needed for tmux commands)
            var pid = -1;
            for (var idx = 0; idx < HyprlandData.windowList.length; idx++) {
                var win = HyprlandData.windowList[idx];
                if (win.class === "kitty" && (win.title === title || title === "")) {
                    if (win.focusHistoryID === 0 || pid === -1)
                        pid = win.pid;
                }
            }
            if (pid > 0) root.kittyPid = pid;

            // Detect tmux session from title: "tmux: kitty - SESSION_NAME"
            if (title.startsWith(root.tmuxTitlePrefix)) {
                var session = title.substring(root.tmuxTitlePrefix.length);
                if (session.length > 0) {
                    root.sessionName = session;
                    root.available = true;
                    root.updateWindowsFromState();
                    if (!ccMonitor.running) ccStartDelay.restart();
                    return;
                }
            }

            // Kitty window without tmux
            root.clearTmuxState();
        }
    }

    function clearTmuxState() {
        available = false;
        sessionName = "";
        windows = [];
        revision++;
    }

    // Fetch full tmux state (all sessions, all clients)
    Process {
        id: fetchState
        command: ["bash", "-c", "~/.config/quickshell/scripts/tmux-state.sh"]
        stdout: StdioCollector {
            id: stateCollector
            onStreamFinished: {
                try {
                    var state = JSON.parse(stateCollector.text);
                    root.allClients = state.clients;
                    root.allWindows = state.windows;
                    root.allPanes = state.panes || {};
                    root.updateWindowsFromState();
                } catch(e) {
                    console.warn("[TmuxService] failed to parse state: " + e);
                }
            }
        }
    }

    function updateWindowsFromState() {
        if (!kittyFocused || sessionName.length === 0) return;
        var result = [];
        for (var i = 0; i < allWindows.length; i++) {
            var w = allWindows[i];
            if (w.session === sessionName) {
                result.push(w);
                if (w.active === 1)
                    activeWindowIndex = w.index;
            }
        }
        windows = result;
        revision++;
    }

    // -CC monitor — one process, sees all events across all sessions
    Timer {
        id: ccStartDelay
        interval: 50
        onTriggered: {
            if (!ccMonitor.running) {
                ccMonitor.running = true;
                // Hide tmux native status bar — QuickShell takes over
                tmuxStatusOff.running = true;
            }
        }
    }

    // Toggle tmux native status bar
    Process {
        id: tmuxStatusOff
        command: ["bash", "-c", "tmux set -g status off; tmux set -g pane-border-status off"]
    }
    Process {
        id: tmuxStatusOn
        command: ["bash", "-c", "tmux set -g status on; tmux set -g pane-border-status top"]
    }

    // Restore tmux status bar when QuickShell exits
    Component.onDestruction: {
        tmuxStatusOn.running = true;
    }

    Process {
        id: ccMonitor
        command: ["bash", "-c", "~/.config/quickshell/scripts/tmux-cc-monitor.sh"]
        stdout: SplitParser {
            onRead: data => {
                // Any filtered event = something changed, refresh state
                refreshDebounce.restart();
            }
        }
    }

    Timer {
        id: refreshDebounce
        interval: 30
        onTriggered: fetchState.running = true
    }

    Component.onCompleted: {
        fetchState.running = true;
        // Kick initial focus detection
        focusSettleTimer.restart();
    }

    // Actions
    function selectWindow(index) {
        selectProc.command = ["tmux", "select-window", "-t", sessionName + ":" + index];
        selectProc.running = true;
    }

    function newWindow() {
        newProc.command = ["tmux", "new-window", "-t", sessionName];
        newProc.running = true;
    }

    function killWindow(index) {
        killProc.command = ["tmux", "kill-window", "-t", sessionName + ":" + index];
        killProc.running = true;
    }

    Process { id: selectProc }
    Process { id: newProc }
    Process { id: killProc }
}
