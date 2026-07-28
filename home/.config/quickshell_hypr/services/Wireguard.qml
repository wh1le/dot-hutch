pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root
    property bool connected: false

    Component.onCompleted: checkState.running = true

    Process {
        id: monitor
        running: true
        command: ["ip", "-d", "monitor", "link"]
        stdout: SplitParser {
            onRead: data => {
                if (data.includes("wireguard")) {
                    stateTimer.restart();
                }
            }
        }
    }

    Timer {
        id: stateTimer
        interval: 500
        repeat: false
        onTriggered: checkState.running = true
    }

    Process {
        id: checkState
        command: ["bash", "-c", "ip link show type wireguard 2>/dev/null"]
        stdout: StdioCollector {
            id: stateCollector
            onStreamFinished: {
                root.connected = root._parseIpLink(stateCollector.text);
            }
        }
    }

    // --- Testable pure JS functions ---
    function _parseIpLink(text) {
        if (!text || text.trim() === "") return false;
        return text.includes("UP");
    }

    function _parseMultipleInterfaces(text) {
        var lines = text.split("\n");
        for (var i = 0; i < lines.length; i++) {
            if (lines[i].includes("UP")) return true;
        }
        return false;
    }
}
