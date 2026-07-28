pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io
import "../.."
import "../../services"

Singleton {
    id: root

    property list<var> results: []
    property string searchText: ""

    readonly property var allApps: DesktopEntries.applications.values

    // Build name->entry map once, rebuild when apps change
    property var nameMap: ({})
    property string _cacheFile: (Quickshell.env("XDG_RUNTIME_DIR") || "/tmp") + "/quickshell-apps-fzf"
    property bool _cacheReady: false

    onAllAppsChanged: {
        const m = {};
        let lines = [];
        for (let i = 0; i < allApps.length; i++) {
            const app = allApps[i];
            if (!(app.name in m))
                m[app.name] = app;
            let parts = [app.name];
            if (app.genericName) parts.push(app.genericName);
            if (app.comment) parts.push(app.comment);
            if (app.keywords && app.keywords.length > 0) parts.push(app.keywords.join(" "));
            if (app.categories && app.categories.length > 0) parts.push(app.categories.join(" "));
            lines.push(parts.join(" | "));
        }
        nameMap = m;

        _cacheReady = false;
        const script = "cat > '" + _cacheFile + "' <<'__APPEOF__'\n" + lines.join("\n") + "\n__APPEOF__";
        cacheProcess.command = ["bash", "-c", script];
        cacheProcess.running = true;

        if (!searchText)
            results = [...allApps];
    }
    Component.onCompleted: { allAppsChanged(); results = [...allApps]; }

    Process {
        id: cacheProcess
        running: false
        onExited: { root._cacheReady = true; }
    }

    Connections {
        target: GlobalStates
        function onAppLauncherOpenChanged() {
            if (!GlobalStates.appLauncherOpen) {
                fzfProcess.running = false;
                root.searchText = "";
            } else {
                root.results = [...root.allApps];
            }
        }
    }

    onSearchTextChanged: {
        if (!searchText) {
            fzfProcess.running = false;
            if (GlobalStates.appLauncherOpen)
                results = [...allApps];
            return;
        }
        runFzf(searchText);
    }

    function runFzf(query) {
        if (!_cacheReady) return;
        fzfProcess.running = false;
        fzfProcess._query = query;

        const qEscaped = query.replace(/'/g, "'\\''");
        fzfProcess.command = ["bash", "-c", "fzf -f '" + qEscaped + "' < '" + _cacheFile + "'"];
        fzfProcess.running = true;
    }

    Process {
        id: fzfProcess
        property string _query: ""
        running: false

        stdout: StdioCollector {
            id: stdoutCollector
            onStreamFinished: {
                const text = stdoutCollector.text.trim();
                const lines = text ? text.split("\n") : [];

                if (fzfProcess._query !== root.searchText) {
                    return;
                }

                if (lines.length === 0) {
                    root.results = [];
                    return;
                }

                const ordered = [];
                const used = {};
                for (let i = 0; i < lines.length; i++) {
                    const name = lines[i].split(" | ")[0];
                    if (name in used) continue;
                    const entry = root.nameMap[name];
                    if (entry) {
                        ordered.push(entry);
                        used[name] = true;
                    }
                }
                root.results = ordered;
            }
        }
    }

    function launch(entry) {
        let parts = [];
        for (let i = 0; i < entry.command.length; i++)
            parts.push(entry.command[i]);
        let cmd = parts.join(" ");
        if (!cmd && entry.id) {
            cmd = "gio launch /run/current-system/sw/share/applications/" + entry.id + ".desktop";
        }
        let script = Quickshell.env("HOME") + "/.config/hypr/scripts/launch-application-same-workspace";
        Logger.log("[Apps] launch: " + cmd + " script: " + script);
        GlobalStates.appLauncherOpen = false;
        launchProcess._cmd = cmd;
        launchProcess._stderr = "";
        launchProcess.command = [script, cmd];
        launchProcess.running = true;
    }

    Process {
        id: launchProcess
        running: false
        property string _cmd: ""
        property string _stderr: ""
        stdout: StdioCollector {
            onStreamFinished: { Logger.log("[Apps] stdout: " + text); }
        }
        stderr: StdioCollector {
            onStreamFinished: { launchProcess._stderr = text; Logger.log("[Apps] stderr: " + text); }
        }
        onExited: (exitCode, exitStatus) => {
            Logger.log("[Apps] exited: code=" + exitCode);
            if (exitCode !== 0) {
                notifyProcess.command = ["notify-send", "-u", "critical", "Launch failed: " + _cmd, _stderr || "exit code " + exitCode];
                notifyProcess.running = true;
            }
        }
    }

    Process {
        id: notifyProcess
        running: false
    }
}
