pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland

Singleton {
    id: root
    property list<string> layoutCodes: []
    property string currentLayoutName: ""
    property string currentLayoutCode: ""
    property bool needsLayoutRefresh: false

    function resolveLayoutCode(layoutName) {
        const name = layoutName.toLowerCase();
        // Match by word boundary: check if code appears as a separate word
        // e.g. "English (US)" matches "us", "Russian" matches "ru" (starts with)
        let bestMatch = "";
        for (let i = 0; i < root.layoutCodes.length; i++) {
            const code = root.layoutCodes[i].trim().toLowerCase();
            // Check: starts with code, or code appears in parentheses, or as a word boundary
            const regex = new RegExp("(?:^|[\\s(])" + code + "(?:[\\s)]|$)", "i");
            if (regex.test(layoutName) && code.length > bestMatch.length) {
                bestMatch = root.layoutCodes[i].trim();
            }
        }
        if (bestMatch) return bestMatch;
        // Fallback: first 2 chars of layout name
        return layoutName.substring(0, 2).toLowerCase();
    }

    Process {
        id: fetchLayoutsProc
        running: true
        command: ["hyprctl", "-j", "devices"]
        stdout: StdioCollector {
            id: devicesCollector
            onStreamFinished: {
                const parsedOutput = JSON.parse(devicesCollector.text);
                const hyprlandKeyboard = parsedOutput["keyboards"].find(kb => kb.main === true);
                root.layoutCodes = hyprlandKeyboard["layout"].split(",").map(s => s.trim());
                const name = hyprlandKeyboard["active_keymap"];
                root.currentLayoutName = name;
                root.currentLayoutCode = root.resolveLayoutCode(name);
            }
        }
    }

    Connections {
        target: Hyprland
        function onRawEvent(event) {
            if (event.name === "activelayout") {
                if (root.needsLayoutRefresh) { root.needsLayoutRefresh = false; fetchLayoutsProc.running = true; return; }
                const dataString = event.data;
                const name = dataString.substring(dataString.indexOf(",") + 1);
                root.currentLayoutName = name;
                root.currentLayoutCode = root.resolveLayoutCode(name);
            } else if (event.name === "configreloaded") {
                root.needsLayoutRefresh = true;
            }
        }
    }

    // --- Testable pure JS functions ---
    function _parseLayoutLine(line, targetDescription) {
        if (!line.trim() || line.trim().startsWith('!')) return null;
        const matchLayout = line.match(/^\s*(\S+)\s+(.+)$/);
        if (matchLayout && matchLayout[2] === targetDescription) return matchLayout[1];
        const matchVariant = line.match(/^\s*(\S+)\s+(\S+)\s+(.+)$/);
        if (matchVariant && matchVariant[3] === targetDescription) return matchVariant[2] + matchVariant[1];
        return null;
    }

    function _layoutNameToCode(name) {
        // Simple first-2-chars lowercase fallback
        if (!name || name.length === 0) return "??";
        return name.substring(0, 2).toLowerCase();
    }
}
