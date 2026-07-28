pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io
import "../.."
import "../../modules/common"

Singleton {
    id: root

    property list<var> results: []
    property string searchText: ""
    property var currentItem: null
    property string currentPreviewRaw: ""
    property bool loading: false
    property bool ready: false

    property var activeItem: null

    readonly property string cacheDir: Quickshell.env("HOME") + "/.cache/quickshell/fzf-source"
    property int maxResults: 50
    readonly property bool showAll: maxResults === 0

    // label -> raw preview text
    property var previewCache: ({})
    property string activeCacheFile: ""

    Component.onCompleted: {
        Quickshell.execDetached(["mkdir", "-p", root.cacheDir]);
    }

    function cacheFile(item) {
        let slug = String(item.source).replace(/[^a-zA-Z0-9]/g, "_").substring(0, 80);
        return root.cacheDir + "/" + slug + ".txt";
    }

    function activate(item) {
        root.activeItem = item;
        root.maxResults = (item.maxResults !== undefined) ? item.maxResults : 50;
        root.searchText = "";
        root.currentPreviewRaw = "";
        root.previewCache = {};
        root.results = [];
        root.loading = true;
        root.ready = false;
        root.activeCacheFile = root.cacheFile(item);

        let cacheTTL = (item.cacheTTL !== undefined) ? item.cacheTTL : 86400;

        if (cacheTTL === 0) {
            // Always fresh — use temp file
            root.activeCacheFile = "/tmp/qs-fzf-live-" + Date.now() + ".txt";
            root.runSource();
            return;
        }
        cacheCheckProcess.command = ["bash", "-c",
            "if [ -f '" + root.activeCacheFile + "' ]; then " +
            "  age=$(( $(date +%s) - $(stat -c %Y '" + root.activeCacheFile + "') )); " +
            "  if [ $age -lt " + cacheTTL + " ]; then echo 'fresh'; else echo 'stale'; fi; " +
            "else echo 'missing'; fi"
        ];
        cacheCheckProcess.running = true;
    }

    function deactivate() {
        fzfProcess.running = false;
        batchPreviewProcess.running = false;
        sourceProcess.running = false;
        root.activeItem = null;
        root.searchText = "";
        root.currentPreviewRaw = "";
        root.results = [];
        root.loading = false;
        root.ready = false;
        root.activeCacheFile = "";
    }

    function onCacheReady() {
        root.ready = true;
        root.loading = false;
        // For live sources (cacheTTL 0), show initial items; for large sources, wait for search
        let cacheTTL = (root.activeItem && root.activeItem.cacheTTL !== undefined) ? root.activeItem.cacheTTL : 86400;
        if (cacheTTL === 0) {
            loadHead();
        } else {
            root.results = [];
        }
    }

    function loadHead() {
        headProcess.command = ["bash", "-c", (root.showAll ? "cat" : "head -n " + root.maxResults) + " '" + root.activeCacheFile + "'"];
        headProcess.running = true;
    }

    Process {
        id: headProcess
        running: false
        stdout: StdioCollector {
            onStreamFinished: {
                root.results = root.parseResults(text);
                root.batchPreload();
            }
        }
    }

    function runSource() {
        if (!root.activeItem) return;
        sourceProcess.command = ["bash", "-c", root.activeItem.source + " > '" + root.activeCacheFile + "'"];
        sourceProcess.running = true;
    }

    function parseResults(text) {
        let lines = text.trim().split("\n").filter(l => l.length > 0);
        let items = [];
        for (let i = 0; i < lines.length && (root.showAll || i < root.maxResults); i++) {
            items.push({ label: lines[i], displayLabel: lines[i] });
        }
        return items;
    }

    // --- Cache check ---
    Process {
        id: cacheCheckProcess
        property int _ttl: 86400
        running: false
        stdout: StdioCollector {
            onStreamFinished: {
                let status = text.trim();
                if (status === "fresh") {
                    root.onCacheReady();
                } else if (status === "stale") {
                    root.onCacheReady();
                    Qt.callLater(root.runSource);
                } else {
                    root.runSource();
                }
            }
        }
    }

    // --- Source command ---
    Process {
        id: sourceProcess
        running: false
        onExited: (exitCode, exitStatus) => {
            root.onCacheReady();
        }
    }

    // --- Fzf filtering ---
    onSearchTextChanged: {
        if (!root.ready) return;
        if (!searchText) {
            let cacheTTL = (root.activeItem && root.activeItem.cacheTTL !== undefined) ? root.activeItem.cacheTTL : 86400;
            if (cacheTTL === 0) {
                loadHead();
            } else {
                root.results = [];
            }
            root.currentItem = null;
            root.currentPreviewRaw = "";
            return;
        }
        runFzf(searchText);
    }

    function runFzf(query) {
        fzfProcess.running = false;
        fzfProcess._query = query;
        const qEscaped = query.replace(/'/g, "'\\''");
        fzfProcess.command = ["bash", "-c",
            "fzf --filter '" + qEscaped + "' < '" + root.activeCacheFile + "'" + (root.showAll ? "" : " | head -n " + root.maxResults)
        ];
        fzfProcess.running = true;
    }

    Process {
        id: fzfProcess
        property string _query: ""
        running: false
        stdout: StdioCollector {
            onStreamFinished: {
                if (fzfProcess._query !== root.searchText) return;
                root.results = root.parseResults(text);
                root.batchPreload();
            }
        }
    }

    // --- Selection -> preview from cache or on-demand ---
    onCurrentItemChanged: {
        if (!root.currentItem) {
            root.currentPreviewRaw = "";
            return;
        }
        let label = root.currentItem.label;
        if (label in root.previewCache) {
            root.currentPreviewRaw = root.previewCache[label];
        } else {
            root.currentPreviewRaw = "";
            if (root.activeItem && root.activeItem.preview) {
                singlePreviewProcess.running = false;
                singlePreviewProcess._label = label;
                let escaped = label.replace(/'/g, "'\\''");
                let cmd = root.activeItem.preview.replace(/\{\}/g, "'" + escaped + "'");
                singlePreviewProcess.command = ["bash", "-c", cmd];
                singlePreviewProcess.running = true;
            }
        }
    }

    Process {
        id: singlePreviewProcess
        property string _label: ""
        running: false
        stdout: StdioCollector {
            onStreamFinished: {
                let label = singlePreviewProcess._label;
                if (text.trim()) {
                    root.previewCache[label] = text;
                    if (root.currentItem && root.currentItem.label === label)
                        root.currentPreviewRaw = text;
                }
            }
        }
    }

    // --- Batch preload previews ---
    function batchPreload() {
        if (!root.activeItem || !root.activeItem.preview || root.results.length === 0) return;

        batchPreviewProcess.running = false;

        let labels = [];
        for (let i = 0; i < root.results.length; i++) {
            let label = root.results[i].label;
            if (label in root.previewCache) continue;
            // Skip binary/file entries — handled on-demand by preview component
            if (label.indexOf("[[ binary data") !== -1 || label.indexOf("file://") !== -1) continue;
            labels.push(label);
        }
        if (labels.length === 0) {
            // All cached — update current
            if (root.currentItem && root.currentItem.label in root.previewCache)
                root.currentPreviewRaw = root.previewCache[root.currentItem.label];
            return;
        }

        let cmds = [];
        for (let i = 0; i < labels.length; i++) {
            let escaped = labels[i].replace(/'/g, "'\\''");
            let previewCmd = root.activeItem.preview.replace(/\{\}/g, "'" + escaped + "'");
            cmds.push("printf '\\x01" + escaped.replace(/\x01/g, "").replace(/\x02/g, "") + "\\x02'");
            cmds.push(previewCmd);
        }

        batchPreviewProcess.command = ["bash", "-c", cmds.join("\n")];
        batchPreviewProcess.running = true;
    }

    Process {
        id: batchPreviewProcess
        running: false
        stdout: StdioCollector {
            onStreamFinished: {
                let parts = text.split("\x01");
                for (let i = 1; i < parts.length; i++) {
                    let sepIdx = parts[i].indexOf("\x02");
                    if (sepIdx === -1) continue;
                    let label = parts[i].substring(0, sepIdx);
                    let raw = parts[i].substring(sepIdx + 1);
                    if (raw) root.previewCache[label] = raw;
                }

                if (root.currentItem && root.currentItem.label in root.previewCache) {
                    root.currentPreviewRaw = root.previewCache[root.currentItem.label];
                }
            }
        }
    }

}
