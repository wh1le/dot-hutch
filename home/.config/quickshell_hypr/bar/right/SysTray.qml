import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Services.SystemTray
import "../../modules/common"
import "../../modules/minimize-tray"
import "../../services"
import "../.."

Item {
    id: root
    implicitWidth: row.implicitWidth
    implicitHeight: row.implicitHeight

    property var activeMenu: null

    function setActiveMenu(menuWindow) {
        if (root.activeMenu && root.activeMenu !== menuWindow && typeof root.activeMenu.close === "function")
            root.activeMenu.close();
        root.activeMenu = menuWindow;
        // Close other popups
        GlobalStates.quickSettingsOpen = false;
        GlobalStates.mediaControlsOpen = false;
    }

    function clearActiveMenu() {
        if (root.activeMenu && typeof root.activeMenu.close === "function")
            root.activeMenu.close();
        root.activeMenu = null;
    }

    Connections {
        target: GlobalStates
        function onQuickSettingsOpenChanged() {
            if (GlobalStates.quickSettingsOpen) root.clearActiveMenu();
        }
        function onMediaControlsOpenChanged() {
            if (GlobalStates.mediaControlsOpen) root.clearActiveMenu();
        }
    }

    HyprlandFocusGrab {
        id: focusGrab
        active: root.activeMenu !== null
        windows: [root.QsWindow?.window, root.activeMenu]
        onCleared: root.clearActiveMenu()
    }

    RowLayout {
        id: row
        anchors.fill: parent
        spacing: 6

        Repeater {
            model: SystemTray.items
            SysTrayItem {
                required property var modelData
                item: modelData
                Layout.alignment: Qt.AlignVCenter
                onMenuOpened: (window) => root.setActiveMenu(window)
                onMenuClosed: root.activeMenu = null
            }
        }

        Repeater {
            model: MinimizeTrayService.items
            MinimizedItem {
                required property var model
                address: model.address
                icon: model.icon
                title: model.title
                appId: model.appId
                hidden: model.hidden
                Layout.alignment: Qt.AlignVCenter
            }
        }
    }
}
