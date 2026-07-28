pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Hyprland

Singleton {
    id: root
    property string activeSubmap: ""

    Connections {
        target: Hyprland
        function onRawEvent(event) {
            if (event.name === "submap") {
                root.activeSubmap = root._parseSubmapEvent(event.data);
            }
        }
    }

    // --- Testable pure JS functions ---
    function _parseSubmapEvent(data) {
        // data comes as just the submap name, empty string means cleared
        if (!data || data.trim() === "") return "";
        return data.trim();
    }
}
