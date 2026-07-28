pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import "../modules/common"

Singleton {
    id: root

    readonly property string logFile: Directories.logPath

    Component.onCompleted: {
        Quickshell.execDetached(["touch", root.logFile]);
    }

    function log(message) {
        let timestamp = new Date().toISOString();
        let line = "[" + timestamp + "] " + message;
        console.log(line);
        logProcess.command = ["bash", "-c", "echo " + JSON.stringify(line) + " >> " + JSON.stringify(root.logFile)];
        logProcess.running = true;
    }

    Process {
        id: logProcess
        running: false
    }
}
