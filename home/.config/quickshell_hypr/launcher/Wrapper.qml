pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import "../modules/common"
import "../services"
import ".."
import "services"

Item {
    id: root

    readonly property bool shouldBeActive: GlobalStates.appLauncherOpen || GlobalStates.menuModeOpen || GlobalStates.fzfPanelOpen
    readonly property bool isMenuMode: GlobalStates.menuModeOpen
    readonly property bool isFzfPanel: GlobalStates.fzfPanelOpen

    visible: shouldBeActive
    implicitWidth: isFzfPanel ? fzfPanelLoader.implicitWidth : content.implicitWidth
    implicitHeight: isFzfPanel ? fzfPanelLoader.implicitHeight : content.implicitHeight

    onShouldBeActiveChanged: {
        if (!shouldBeActive) {
            Apps.searchText = "";
            MenuMode.searchText = "";
        }
    }

    Connections {
        target: HyprlandData
        function onActiveWorkspaceChanged() {
            if (GlobalStates.appLauncherOpen)
                GlobalStates.appLauncherOpen = false;
            if (GlobalStates.menuModeOpen)
                GlobalStates.menuModeOpen = false;
            if (GlobalStates.fzfPanelOpen)
                GlobalStates.fzfPanelOpen = false;
        }
    }

    Connections {
        target: GlobalStates
        function onFzfPanelOpenChanged() {
            if (!GlobalStates.fzfPanelOpen) {
                FzfSource.deactivate();
            }
        }
    }

    Loader {
        id: content
        anchors.fill: parent
        active: root.shouldBeActive && !root.isFzfPanel
        sourceComponent: Content {
            isMenuMode: root.isMenuMode
        }
    }

    Loader {
        id: fzfPanelLoader
        anchors.fill: parent
        active: root.isFzfPanel
        sourceComponent: FzfPanel {}
    }
}
