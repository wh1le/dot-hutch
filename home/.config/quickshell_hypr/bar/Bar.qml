import QtQuick
import Quickshell
import Quickshell.Wayland
import "../modules/common"

Variants {
    model: Quickshell.screens

    PanelWindow {
        id: barWindow
        required property var modelData
        screen: modelData

        anchors { top: true; left: true; right: true }
        implicitHeight: Appearance.sizes.barHeight
        color: "transparent"
        exclusionMode: ExclusionMode.Auto

        WlrLayershell.layer: WlrLayer.Top
        WlrLayershell.namespace: "quickshell-bar"

        BarContent {
            anchors.fill: parent
            screenWidth: barWindow.width
        }
    }
}
