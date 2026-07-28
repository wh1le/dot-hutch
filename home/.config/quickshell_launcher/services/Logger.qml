pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import "../modules"

Singleton {
    id: root

    readonly property string logFile: Config.options.directories ? Config.options.directories.logPath : ""

    onLogFileChanged: if (logFile.length > 0) Quickshell.execDetached(["touch", logFile]);

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
