pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import "../modules"
import "../services"
import ".."
import "services"

FocusScope {
    id: root

    // Forward window focus down into whichever Loader is active so the search
    // input (which self-focuses) actually receives keystrokes without a click.
    focus: true

    readonly property bool shouldBeActive: GlobalStates.appLauncherOpen || GlobalStates.menuModeOpen || GlobalStates.fzfPanelOpen || GlobalStates.otpPromptOpen
    readonly property bool isMenuMode: GlobalStates.menuModeOpen
    readonly property bool isFzfPanel: GlobalStates.fzfPanelOpen
    readonly property bool isOtpPrompt: GlobalStates.otpPromptOpen

    visible: shouldBeActive
    implicitWidth: isOtpPrompt ? otpPromptLoader.implicitWidth : (isFzfPanel ? fzfPanelLoader.implicitWidth : content.implicitWidth)
    implicitHeight: isOtpPrompt ? otpPromptLoader.implicitHeight : (isFzfPanel ? fzfPanelLoader.implicitHeight : content.implicitHeight)

    onShouldBeActiveChanged: {
        if (!shouldBeActive) {
            Apps.searchText = "";
            MenuMode.searchText = "";
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
        active: root.shouldBeActive && !root.isFzfPanel && !root.isOtpPrompt
        focus: active
        sourceComponent: Content {
            isMenuMode: root.isMenuMode
        }
    }

    Loader {
        id: fzfPanelLoader
        anchors.fill: parent
        active: root.isFzfPanel
        focus: active
        sourceComponent: FzfPanel {}
    }

    Loader {
        id: otpPromptLoader
        anchors.fill: parent
        active: root.isOtpPrompt
        focus: active
        sourceComponent: OtpPromptPanel {}
    }
}
