//@ pragma UseQApplication
//@ pragma Env QT_QUICK_CONTROLS_STYLE=Basic
//@ pragma Env QT_QUICK_FLICKABLE_WHEEL_DECELERATION=10000
//@ pragma Env RESOURCE_NAME=quickshell_launcher

import "modules"
import "services"
import "launcher"
import "launcher/services"

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.I3

ShellRoot {
    id: root

    Component.onCompleted: {
        Quickshell.reloadPopup = false;
        MaterialThemeLoader.reapplyTheme();
        // Force launcher singletons to load eagerly
        void MenuMode.results;
        void FzfSource.results;
    }

    function closeAll() {
        GlobalStates.appLauncherOpen = false;
        GlobalStates.menuModeOpen = false;
        GlobalStates.fzfPanelOpen = false;
        GlobalStates.otpPromptOpen = false;
    }

    // Toggle the app launcher
    IpcHandler {
        target: "launcher"
        function toggle(): void {
            GlobalStates.menuModeOpen = false;
            GlobalStates.fzfPanelOpen = false;
            GlobalStates.appLauncherOpen = !GlobalStates.appLauncherOpen;
        }
    }

    // Toggle menu mode (fzm)
    IpcHandler {
        target: "menu"
        function toggle(): void {
            GlobalStates.appLauncherOpen = false;
            GlobalStates.fzfPanelOpen = false;
            GlobalStates.menuModeOpen = !GlobalStates.menuModeOpen;
        }
    }

    // Quick copy panel
    IpcHandler {
        target: "quick-copy"
        function toggle(): void {
            GlobalStates.appLauncherOpen = false;
            GlobalStates.menuModeOpen = false;
            if (GlobalStates.fzfPanelOpen) {
                GlobalStates.fzfPanelOpen = false;
            } else {
                let item = MenuMode.labelMap["Quick Copy"];
                if (item) {
                    GlobalStates.fzfPanelOpen = true;
                    FzfSource.activate(item);
                }
            }
        }
    }

    FloatingWindow {
        id: win
        title: "quickshell-launcher"
        color: "transparent"

        readonly property bool open: GlobalStates.appLauncherOpen
            || GlobalStates.menuModeOpen
            || GlobalStates.fzfPanelOpen
            || GlobalStates.otpPromptOpen

        visible: open
        implicitWidth: wrapper.implicitWidth > 0 ? wrapper.implicitWidth : 600
        implicitHeight: wrapper.implicitHeight > 0 ? wrapper.implicitHeight : 400
        minimumSize: Qt.size(implicitWidth, implicitHeight)
        maximumSize: Qt.size(implicitWidth, implicitHeight)

        // Initial float + center is enforced i3-side via a `for_window` rule
        // (see i3 config), so no global window-event listener is needed here.
        // We only re-center while open, when the window resizes (e.g. the fzf
        // preview pane shows/hides) — i3's map-time center won't catch that.
        function center() {
            if (!open) return;
            I3.dispatch('[instance="' + Config.options.launcher.windowClass + '"] '
                + 'move position center, focus');
        }

        onImplicitHeightChanged: center()
        onImplicitWidthChanged: center()

        // No `focus` here: a plain Item with focus would trap active focus and
        // never forward it down. Wrapper is a FocusScope (focus: true) and the
        // search input inside it self-focuses, so keystrokes land there. Esc is
        // handled by the input's own Keys.onEscapePressed.
        Item {
            anchors.fill: parent

            Wrapper {
                id: wrapper
                anchors.centerIn: parent
            }
        }
    }
}
