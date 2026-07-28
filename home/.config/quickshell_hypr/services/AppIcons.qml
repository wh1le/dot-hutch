pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property var cache: ({})
    readonly property string cacheFile: (Quickshell.env("HOME") || "/tmp") + "/.cache/quickshell/icon-cache.json"

    Component.onCompleted: loadProc.running = true

    property var _warmQueue: []
    property int _warmIndex: 0

    function warmUp() {
        const apps = DesktopEntries.applications.values;
        _warmQueue = [];
        for (let i = 0; i < apps.length; i++) {
            const icon = apps[i].icon;
            if (icon && !(icon in cache)) _warmQueue.push(icon);
        }
        _warmIndex = 0;
        if (_warmQueue.length > 0) _warmTimer.start();
    }

    Timer {
        id: _warmTimer
        interval: 1
        repeat: true
        onTriggered: {
            const batch = 5;
            for (let i = 0; i < batch && root._warmIndex < root._warmQueue.length; i++, root._warmIndex++) {
                root.get(root._warmQueue[root._warmIndex]);
            }
            if (root._warmIndex >= root._warmQueue.length) {
                stop();
                root._warmQueue = [];
            }
        }
    }

    function get(name) {
        if (!name) return "";
        if (name in cache) return cache[name];
        const resolved = Quickshell.iconPath(_resolve(name), "image-missing");
        cache[name] = resolved;
        _dirty = true;
        _saveDebounce.restart();
        return resolved;
    }

    function guessIcon(str) {
        return _resolve(str);
    }

    property bool _dirty: false

    function _iconExists(iconName) {
        if (!iconName || iconName.length === 0) return false;
        return Quickshell.iconPath(iconName, true).length > 0
            && !iconName.includes("image-missing");
    }

    function _resolve(str) {
        if (!str || str.length === 0) return "application-x-executable";

        const entry = DesktopEntries.byId(str);
        if (entry) return entry.icon;

        if (_iconExists(str)) return str;

        const lowercased = str.toLowerCase();
        if (_iconExists(lowercased)) return lowercased;

        const lastPart = str.split('.').slice(-1)[0];
        if (_iconExists(lastPart)) return lastPart;
        const lastPartLower = lastPart.toLowerCase();
        if (_iconExists(lastPartLower)) return lastPartLower;

        const kebab = str.toLowerCase().replace(/\s+/g, "-");
        if (_iconExists(kebab)) return kebab;

        const underscoreKebab = str.toLowerCase().replace(/_/g, "-");
        if (_iconExists(underscoreKebab)) return underscoreKebab;

        const heuristicEntry = DesktopEntries.heuristicLookup(str);
        if (heuristicEntry) return heuristicEntry.icon;

        return "application-x-executable";
    }

    Timer {
        id: _saveDebounce
        interval: 2000
        onTriggered: root._save()
    }

    function _save() {
        if (!_dirty) return;
        _dirty = false;
        const json = JSON.stringify(cache).replace(/'/g, "'\\''");
        saveProc.command = ["bash", "-c", "mkdir -p \"$(dirname '" + cacheFile + "')\" && printf '%s' '" + json + "' > '" + cacheFile + "'"];
        saveProc.running = true;
    }

    Process {
        id: saveProc
    }

    Process {
        id: loadProc
        command: ["cat", root.cacheFile]
        stdout: StdioCollector {
            onStreamFinished: {
                try { root.cache = JSON.parse(text); }
                catch(e) { root.cache = {}; }
                root.warmUp();
            }
        }
        onExited: (code) => { if (code !== 0) root.warmUp(); }
    }
}
