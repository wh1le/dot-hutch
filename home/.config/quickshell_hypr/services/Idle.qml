pragma Singleton
import "../modules/common"
import QtQuick
import Quickshell
import Quickshell.Wayland

Singleton {
    id: root
    property alias inhibit: idleInhibitor.enabled

    function toggleInhibit(active = null) {
        if (active !== null) root.inhibit = active;
        else root.inhibit = !root.inhibit;
    }

    IdleInhibitor {
        id: idleInhibitor
        window: PanelWindow {
            implicitWidth: 0
            implicitHeight: 0
            color: "transparent"
            anchors { right: true; bottom: true }
            mask: Region { item: null }
        }
    }
}
