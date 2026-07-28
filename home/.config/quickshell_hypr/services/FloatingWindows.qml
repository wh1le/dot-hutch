pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland

Singleton {
    id: root
    property int count: 0
    property int activeWorkspaceId: -1

    Component.onCompleted: refresh()

    Connections {
        target: Hyprland
        function onRawEvent(event) {
            if (["openwindow", "closewindow", "movewindow", "changefloatingmode", "workspace", "activewindow"].includes(event.name)) {
                refreshTimer.restart();
            }
        }
    }

    Timer {
        id: refreshTimer
        interval: 100
        repeat: false
        onTriggered: root.refresh()
    }

    function refresh() {
        getActiveWs.running = true;
    }

    Process {
        id: getActiveWs
        command: ["hyprctl", "-j", "activeworkspace"]
        stdout: StdioCollector {
            id: activeWsCollector
            onStreamFinished: {
                const ws = JSON.parse(activeWsCollector.text);
                root.activeWorkspaceId = ws.id;
                getClients.running = true;
            }
        }
    }

    Process {
        id: getClients
        command: ["hyprctl", "-j", "clients"]
        stdout: StdioCollector {
            id: clientsCollector
            onStreamFinished: {
                const clients = JSON.parse(clientsCollector.text);
                root.count = root._countFloating(clients, root.activeWorkspaceId);
            }
        }
    }

    // --- Testable pure JS functions ---
    function _countFloating(clients, workspaceId) {
        return clients.filter(c => c.floating === true && c.workspace.id === workspaceId).length;
    }
}
