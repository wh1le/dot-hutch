pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io
import "../modules/common"
import "../modules/common/functions"

Singleton {
    id: root

    property bool visible: false
    property string description: ""
    property string prompt: ""
    property string error: ""
    property string responseFile: ""

    function request(desc, prompt, error, file) {
        root.description = desc.replace(/%0A/g, "\n").replace(/%25/g, "%");
        root.prompt = prompt || "Passphrase:";
        root.error = error;
        root.responseFile = file;
        root.visible = true;
    }

    function submit(pin) {
        if (root.responseFile) {
            writeResponse.command = ["bash", "-c", "printf '%s' " + JSON.stringify(pin) + " > " + JSON.stringify(root.responseFile)];
            writeResponse.running = true;
        }
        root.visible = false;
        root.description = "";
        root.prompt = "";
        root.error = "";
        root.responseFile = "";
    }

    function cancel() {
        if (root.responseFile) {
            writeResponse.command = ["bash", "-c", "printf '__CANCEL__' > " + JSON.stringify(root.responseFile)];
            writeResponse.running = true;
        }
        root.visible = false;
        root.description = "";
        root.prompt = "";
        root.error = "";
        root.responseFile = "";
    }

    Process {
        id: writeResponse
        running: false
    }
}
