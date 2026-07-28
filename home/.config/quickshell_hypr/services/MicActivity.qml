pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root
    property bool active: false
    readonly property list<string> monitoredApps: ["firefox", "zoom", "chromium"]

    Component.onCompleted: checkMic.running = true

    Process {
        id: subscriber
        running: true
        command: ["pactl", "subscribe"]
        stdout: SplitParser {
            onRead: data => {
                if (data.includes("source-output")) {
                    checkTimer.restart();
                }
            }
        }
    }

    Timer {
        id: checkTimer
        interval: 300
        repeat: false
        onTriggered: checkMic.running = true
    }

    Process {
        id: checkMic
        command: ["pactl", "list", "source-outputs"]
        stdout: StdioCollector {
            id: micCollector
            onStreamFinished: {
                root.active = root._parsePactlOutput(micCollector.text, root.monitoredApps);
            }
        }
    }

    // --- Testable pure JS functions ---
    function _parsePactlOutput(text, appList) {
        var lower = text.toLowerCase();
        for (var i = 0; i < appList.length; i++) {
            if (lower.includes(appList[i])) return true;
        }
        return false;
    }
}
