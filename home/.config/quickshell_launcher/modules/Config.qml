pragma Singleton
pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Io

// Configuration is sourced from `config.yaml` (Directories.shellConfigPath).
// YAML has no native Quickshell parser, so we shell out to `yq` to transcode
// it to JSON and parse that. Config is read-only at runtime.
Singleton {
    id: root
    property string filePath: Directories.shellConfigPath
    property var options: ({})
    property bool ready: false

    // Default Material palette (Colors.qml fallback; pywal overrides at runtime).
    property string colorsPath: Directories.shellConfig + "/colors.yaml"
    property var colors: ({})
    property bool colorsReady: false

    function reload() {
        yqProcess.running = false;
        yqProcess.running = true;
    }

    function reloadColors() {
        colorsProcess.running = false;
        colorsProcess.running = true;
    }

    // Recursively expand ${HOME} in every string value — yq does not touch env.
    function expandHome(node) {
        const home = Quickshell.env("HOME");
        if (typeof node === "string")
            return node.replace("${HOME}", home);
        if (Array.isArray(node))
            return node.map(expandHome);
        if (node && typeof node === "object") {
            for (const k in node)
                node[k] = expandHome(node[k]);
            return node;
        }
        return node;
    }

    // Parsed once at startup — no file watching, no timers (battery/CPU).
    // Edits to config.yaml/colors.yaml require a shell reload to take effect.
    Component.onCompleted: { reload(); reloadColors(); }

    Process {
        id: colorsProcess
        command: ["yq", ".", root.colorsPath]
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    root.colors = JSON.parse(this.text);
                    root.colorsReady = true;
                } catch (e) {
                    console.error("[Config] failed to parse colors.yaml:", e);
                }
            }
        }
        stderr: StdioCollector {
            onStreamFinished: {
                if (this.text.length > 0)
                    console.error("[Config] yq (colors):", this.text);
            }
        }
    }

    Process {
        id: yqProcess
        command: ["yq", ".", root.filePath]
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    root.options = root.expandHome(JSON.parse(this.text));
                    root.ready = true;
                } catch (e) {
                    console.error("[Config] failed to parse config.yaml:", e);
                }
            }
        }
        stderr: StdioCollector {
            onStreamFinished: {
                if (this.text.length > 0)
                    console.error("[Config] yq:", this.text);
            }
        }
    }
}
