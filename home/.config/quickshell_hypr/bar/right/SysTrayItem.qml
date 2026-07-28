pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Widgets
import "../../modules/common"
import "../../services"

MouseArea {
    id: root
    required property SystemTrayItem item

    signal menuOpened(qsWindow: var)
    signal menuClosed()

    hoverEnabled: true
    acceptedButtons: Qt.LeftButton | Qt.RightButton
    implicitWidth: Appearance.sizes.barMaterialIconSize
    implicitHeight: Appearance.sizes.barMaterialIconSize

    onPressed: (event) => {
        switch (event.button) {
        case Qt.LeftButton:
            item.activate();
            break;
        case Qt.RightButton:
            if (item.hasMenu)
                if (menu.active && menu.item && typeof menu.item.close === "function")
                    menu.item.close();
                else
                    menu.open();
            break;
        }
        event.accepted = true;
    }

    Loader {
        id: menu
        function open() {
            menu.active = true;
        }
        active: false
        sourceComponent: SysTrayMenu {
            Component.onCompleted: this.open()
            trayItemMenuHandle: root.item.menu
            trayItemId: root.item.id
            anchor {
                window: root.QsWindow.window
                item: root
                gravity: Edges.Bottom
                edges: Edges.Bottom
            }
            onMenuOpened: (window) => root.menuOpened(window)
            onMenuClosed: {
                root.menuClosed();
                menu.active = false;
            }
        }
    }

    IconImage {
        id: iconImg
        source: root.item.icon
        anchors.centerIn: parent
        width: parent.width
        height: parent.height
        visible: status === Image.Ready
    }

    // Fallback: resolve via system icon theme
    IconImage {
        visible: !iconImg.visible
        source: Quickshell.iconPath(AppIcons.guessIcon(root.item.id), "image-missing")
        anchors.centerIn: parent
        width: parent.width
        height: parent.height
    }
}
