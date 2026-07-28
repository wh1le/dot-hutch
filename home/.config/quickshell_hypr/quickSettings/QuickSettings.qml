import QtQuick
import Quickshell
import Quickshell.Wayland
import "../modules/common"
import ".."

PanelWindow {
    id: root
    anchors { top: true; right: true }
    implicitWidth: Appearance.sizes.quickSettingsWidth
    implicitHeight: contentLoader.item?.implicitHeight + 16 ?? 200
    color: "transparent"
    visible: GlobalStates.quickSettingsOpen
    exclusionMode: ExclusionMode.Ignore

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "quickshell-quicksettings"

    MouseArea {
        anchors.fill: parent
        onClicked: GlobalStates.quickSettingsOpen = false
        z: -1
    }

    Loader {
        id: contentLoader
        anchors.fill: parent
        anchors.margins: 8
        active: GlobalStates.quickSettingsOpen
        sourceComponent: QuickSettingsContent {}
    }
}
