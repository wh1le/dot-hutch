pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io
import "../.."

Singleton {
    id: root

    readonly property string script: Quickshell.env("HOME") + "/.config/quickshell_launcher/scripts/pass-scan-otp"

    property string otpUri: ""
    property string defaultName: ""

    // Region-select + decode a QR, then open the name prompt.
    function scan() {
        GlobalStates.appLauncherOpen = false;
        GlobalStates.menuModeOpen = false;
        GlobalStates.fzfPanelOpen = false;
        scanProcess.running = false;
        scanProcess.command = [root.script, "scan"];
        scanProcess.running = true;
    }

    function submit(name) {
        GlobalStates.otpPromptOpen = false;
        const n = String(name).trim();
        if (!n || !root.otpUri) return;
        saveProcess.command = [root.script, "save", root.otpUri, n];
        saveProcess.running = true;
    }

    function cancel() {
        GlobalStates.otpPromptOpen = false;
        root.otpUri = "";
    }

    Process {
        id: scanProcess
        running: false
        stdout: StdioCollector {
            id: scanOut
            onStreamFinished: {
                const lines = scanOut.text.split("\n");
                const uri = (lines[0] || "").trim();
                if (uri.indexOf("otpauth://") !== 0) return; // cancelled / no QR
                root.otpUri = uri;
                root.defaultName = (lines[1] || "").trim();
                GlobalStates.otpPromptOpen = true;
            }
        }
    }

    Process { id: saveProcess; running: false }
}
