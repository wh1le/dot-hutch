pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root
    property bool mounted: false

    Component.onCompleted: checkMount.running = true

    Process {
        id: watcher
        running: true
        command: ["inotifywait", "-m", "-e", "create,delete", "/mnt"]
        stdout: SplitParser {
            onRead: {
                mountTimer.restart();
            }
        }
    }

    Timer {
        id: mountTimer
        interval: 500
        repeat: false
        onTriggered: checkMount.running = true
    }

    Process {
        id: checkMount
        command: ["mount"]
        stdout: StdioCollector {
            id: mountCollector
            onStreamFinished: {
                root.mounted = root._parseMountOutput(mountCollector.text);
            }
        }
    }

    // --- Testable pure JS functions ---
    function _parseMountOutput(text) {
        if (!text || text.trim() === "") return false;
        return /\s+on\s+\/mnt\/personal_\S+\s+/.test(text);
    }
}
