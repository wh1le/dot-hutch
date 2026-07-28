pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io
import "../modules/common"

Singleton {
    id: root

    property var services: Config.ready ? (Config.options.tray.systemdServices ?? []) : []
    property var statuses: ({})

    onServicesChanged: pollAll()
    Component.onCompleted: pollAll()

    Timer {
        interval: 10000
        running: root.services.length > 0
        repeat: true
        onTriggered: root.pollAll()
    }

    function pollAll() {
        for (let i = 0; i < services.length; i++) {
            pollService(services[i].name, services[i].user ?? false);
        }
    }

    function pollService(name, isUser) {
        let cmd = ["systemctl"];
        if (isUser) cmd.push("--user");
        cmd.push("status", "--no-pager", name);
        let proc = pollComponent.createObject(root, { serviceName: name, command: cmd });
        proc.running = true;
    }

    function _parseStatus(name, text) {
        let lines = text.split("\n");
        let result = { name: name, active: "unknown", sub: "", description: "", loaded: "" };
        for (let i = 0; i < lines.length; i++) {
            let line = lines[i].trim();
            if (line.startsWith("Active:")) {
                let m = line.match(/Active:\s+(\S+)\s+\((\S+)\)/);
                if (m) { result.active = m[1]; result.sub = m[2]; }
            } else if (line.startsWith("Loaded:")) {
                result.loaded = line.substring(8).trim();
            } else if (i === 0 && (line.includes(".service") || line.includes(".target"))) {
                let m = line.match(/- (.+)$/);
                if (m) result.description = m[1];
            }
        }
        return result;
    }

    Component {
        id: pollComponent
        Process {
            id: proc
            property string serviceName
            stdout: StdioCollector {
                id: collector
                onStreamFinished: {
                    let s = root._parseStatus(proc.serviceName, collector.text);
                    let copy = Object.assign({}, root.statuses);
                    copy[proc.serviceName] = s;
                    root.statuses = copy;
                    proc.destroy();
                }
            }
        }
    }
}
