import QtQuick
import Quickshell
import Quickshell.Wayland
import "modules/common"
import "services"

Scope {
    id: root
    required property var screen
    property real borderWidth: 2
    property bool fullscreen: Fullscreen.onScreen(root.screen)

    // Top (bar)
    PanelWindow {
        screen: root.screen
        anchors.top: true
        exclusiveZone: root.fullscreen ? 0 : Appearance.sizes.barHeight
        exclusionMode: ExclusionMode.Normal
        mask: Region {}
        implicitWidth: 1
        implicitHeight: 1
        color: "transparent"
        WlrLayershell.layer: WlrLayer.Top
        WlrLayershell.namespace: "quickshell-exclusion"
    }

    // Left (sidebar)
    PanelWindow {
        screen: root.screen
        anchors.left: true
        exclusiveZone: root.fullscreen ? 0 : 30
        exclusionMode: ExclusionMode.Normal
        mask: Region {}
        implicitWidth: 1
        implicitHeight: 1
        color: "transparent"
        WlrLayershell.layer: WlrLayer.Top
        WlrLayershell.namespace: "quickshell-exclusion"
    }

    // Right
    PanelWindow {
        screen: root.screen
        anchors.right: true
        exclusiveZone: root.fullscreen ? 0 : root.borderWidth
        exclusionMode: ExclusionMode.Normal
        mask: Region {}
        implicitWidth: 1
        implicitHeight: 1
        color: "transparent"
        WlrLayershell.layer: WlrLayer.Top
        WlrLayershell.namespace: "quickshell-exclusion"
    }
}
