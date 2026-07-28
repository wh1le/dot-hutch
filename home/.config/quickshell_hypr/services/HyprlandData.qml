pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland

Singleton {
    id: root
    property var windowList: []
    property var addresses: []
    property var windowByAddress: ({})
    property var workspaces: []
    property var workspaceIds: []
    property var workspaceById: ({})
    property var activeWorkspace: null
    property var monitors: []
    property bool hasFullscreenWindow: {
        if (!root.activeWorkspace) return false;
        var wsId = root.activeWorkspace.id;
        return root.windowList.some(function(w) {
            return w.workspace.id === wsId && (w.fullscreen > 0 || w.fullscreenClient > 0);
        });
    }

    function hyprlandClientsForWorkspace(workspace) {
        return root.windowList.filter(win => win.workspace.id === workspace);
    }

    function biggestWindowForWorkspace(workspaceId) {
        const windowsInThisWorkspace = root.windowList.filter(w => w.workspace.id == workspaceId);
        return windowsInThisWorkspace.reduce((maxWin, win) => {
            const maxArea = (maxWin?.size?.[0] ?? 0) * (maxWin?.size?.[1] ?? 0);
            const winArea = (win?.size?.[0] ?? 0) * (win?.size?.[1] ?? 0);
            return winArea > maxArea ? win : maxWin;
        }, null);
    }

    Component.onCompleted: updateAll()

    function updateAll() {
        getClients.running = true;
        getWorkspaces.running = true;
        getActiveWorkspace.running = true;
        getMonitors.running = true;
    }

    Connections {
        target: Hyprland
        function onRawEvent(event) {
            if (["openlayer", "closelayer", "screencast"].includes(event.name)) return;
            updateAll()
        }
    }

    Process {
        id: getClients
        command: ["hyprctl", "clients", "-j"]
        stdout: StdioCollector {
            id: clientsCollector
            onStreamFinished: {
                root.windowList = JSON.parse(clientsCollector.text)
                let tempWinByAddress = {};
                for (var i = 0; i < root.windowList.length; ++i) {
                    var win = root.windowList[i];
                    tempWinByAddress[win.address] = win;
                }
                root.windowByAddress = tempWinByAddress;
                root.addresses = root.windowList.map(win => win.address);
            }
        }
    }

    Process {
        id: getMonitors
        command: ["hyprctl", "monitors", "-j"]
        stdout: StdioCollector {
            id: monitorsCollector
            onStreamFinished: { root.monitors = JSON.parse(monitorsCollector.text); }
        }
    }

    Process {
        id: getWorkspaces
        command: ["hyprctl", "workspaces", "-j"]
        stdout: StdioCollector {
            id: workspacesCollector
            onStreamFinished: {
                var rawWorkspaces = JSON.parse(workspacesCollector.text);
                root.workspaces = rawWorkspaces.filter(ws => ws.id >= 1 && ws.id <= 100);
                let tempWorkspaceById = {};
                for (var i = 0; i < root.workspaces.length; ++i) {
                    var ws = root.workspaces[i];
                    tempWorkspaceById[ws.id] = ws;
                }
                root.workspaceById = tempWorkspaceById;
                root.workspaceIds = root.workspaces.map(ws => ws.id);
            }
        }
    }

    Process {
        id: getActiveWorkspace
        command: ["hyprctl", "activeworkspace", "-j"]
        stdout: StdioCollector {
            id: activeWorkspaceCollector
            onStreamFinished: { root.activeWorkspace = JSON.parse(activeWorkspaceCollector.text); }
        }
    }

    // --- Testable pure JS functions ---
    function _filterWorkspaces(workspaces) {
        return workspaces.filter(ws => ws.id >= 1 && ws.id <= 100);
    }

    function _filterFloatingClients(clients, workspaceId) {
        return clients.filter(c => c.floating === true && c.workspace.id === workspaceId);
    }

    function _biggestWindow(clients) {
        return clients.reduce((maxWin, win) => {
            const maxArea = (maxWin?.size?.[0] ?? 0) * (maxWin?.size?.[1] ?? 0);
            const winArea = (win?.size?.[0] ?? 0) * (win?.size?.[1] ?? 0);
            return winArea > maxArea ? win : maxWin;
        }, null);
    }
}
