pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io
import "../.."
import "../../modules"
import "../../services"
import "."

Singleton {
    id: root

    property list<var> results: []
    property string searchText: ""
    property list<var> allItems: []
    property var labelMap: ({})

    Component.onCompleted: loadItems()

    function loadItems() {
        const raw = Config.options.menuItems;
        if (!raw) return;
        const items = [];
        const m = {};
        const defaults = Config.options.launcher;

        for (let i = 0; i < raw.length; i++) {
            const r = raw[i];
            const item = {
                icon:    r.icon    || "",
                label:   r.label   || "",
                option:  r.option  || "",
                script:  r.script  || "",
                silent:  !!r.silent,
                handler: r.handler || "",
                action:  r.action  || "",
                source:  r.source  || "",
                preview: r.preview || "",
                previewFormat: r.previewFormat || "",
                sourceLabel: r.sourceLabel || "",
                unstable: !!r.unstable,
                cacheTTL: r.cacheTTL !== undefined ? r.cacheTTL : 86400,
                selectAction: r.selectAction || "",
                maxResults: r.maxResults !== undefined ? r.maxResults : 50,
                args:    r.args    || "",
                width:   r.w       || defaults.termWidth,
                height:  r.h       || defaults.termHeight,
                fontSize: r.fs     || defaults.termFontSize
            };
            item.displayLabel = item.icon + "  " + item.label;
            items.push(item);
            if (!(item.label in m))
                m[item.label] = item;
        }
        allItems = items;
        labelMap = m;
        results = [...items];
        console.log("[MenuMode] loaded", items.length, "items");
    }

    // Watch config changes
    Connections {
        target: Config
        function onOptionsChanged() { root.loadItems(); }
    }

    Connections {
        target: GlobalStates
        function onMenuModeOpenChanged() {
            if (!GlobalStates.menuModeOpen) {
                fzfProcess.running = false;
                root.searchText = "";
                root.results = [...root.allItems];
            }
        }
    }

    onSearchTextChanged: {
        if (!searchText) {
            results = [...allItems];
            return;
        }
        runFzf(searchText);
    }

    function runFzf(query) {
        fzfProcess.running = false;
        fzfProcess._query = query;

        let labels = [];
        for (let i = 0; i < allItems.length; i++)
            labels.push(allItems[i].label);

        const qEscaped = query.replace(/'/g, "'\\''");
        const script = "cat <<'__MENUEOF__' | fzf --filter '" + qEscaped + "'\n" + labels.join("\n") + "\n__MENUEOF__";
        fzfProcess.command = ["bash", "-c", script];
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
                const matchedLabels = text ? text.split("\n") : [];

                if (fzfProcess._query !== root.searchText)
                    return;

                if (matchedLabels.length === 0) {
                    root.results = [];
                    return;
                }

                const ordered = [];
                const used = {};
                for (let i = 0; i < matchedLabels.length; i++) {
                    const label = matchedLabels[i];
                    if (label in used) continue;
                    const entry = root.labelMap[label];
                    if (entry) {
                        ordered.push(entry);
                        used[label] = true;
                    }
                }
                root.results = ordered;
            }
        }
    }

    function launch(item) {
        // Source-based items: transition to FzfPanel without dropping focus grab
        if (item.source) {
            GlobalStates.fzfPanelOpen = true;
            GlobalStates.menuModeOpen = false;
            FzfSource.activate(item);
            return;
        }

        GlobalStates.menuModeOpen = false;

        // Internal actions (no terminal needed)
        if (item.action) {
            if (item.action === "wallpaper-picker") {
                GlobalStates.wallpaperPickerOpen = true;
            } else if (item.action === "applications") {
                GlobalStates.appLauncherOpen = true;
            } else if (item.action === "scan-otp") {
                OtpPrompt.scan();
            }
            return;
        }

        var cmd;
        if (item.option) {
            cmd = "$HOME/.config/quickshell_launcher/scripts/" + item.option;
            if (item.args)
                cmd += " " + item.args;
        } else if (item.script) {
            cmd = item.script;
        } else {
            return;
        }

        // Silent scripts run in the background: no terminal, feedback via notify-send.
        if (item.silent) {
            Quickshell.execDetached(["bash", "-c", cmd]);
            return;
        }

        // i3 floats the terminal via a static `for_window` rule (see i3 config);
        // kitty sets the actual geometry through initial_window_{width,height}.
        var terminal = Config.options.launcher.terminal;
        Quickshell.execDetached({
            command: [
                terminal,
                "--class", "terminal-quickshell",
                "--override", "font_size=" + item.fontSize,
                "--override", "initial_window_width=" + item.width,
                "--override", "initial_window_height=" + item.height,
                "bash", "-c", cmd
            ]
        });
    }
}
