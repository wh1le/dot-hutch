pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import "../../modules/common"
import "../../modules/common/widgets"

PopupWindow {
    id: root
    required property QsMenuHandle trayItemMenuHandle
    property string trayItemId: ""

    signal menuClosed
    signal menuOpened(qsWindow: var)

    color: "transparent"
    property real padding: 2

    implicitHeight: {
        let result = 0;
        for (let child of stackView.children) {
            result = Math.max(child.implicitHeight, result);
        }
        return result + popupBackground.padding * 2 + root.padding * 2;
    }
    implicitWidth: {
        let result = 0;
        for (let child of stackView.children) {
            result = Math.max(child.implicitWidth, result);
        }
        return result + popupBackground.padding * 2 + root.padding * 2;
    }

    function open() {
        root.visible = true;
        root.menuOpened(root);
    }

    function close() {
        root.visible = false;
        while (stackView.depth > 1)
            stackView.pop();
        root.menuClosed();
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.BackButton | Qt.RightButton
        onPressed: event => {
            if ((event.button === Qt.BackButton || event.button === Qt.RightButton) && stackView.depth > 1)
                stackView.pop();
        }

        Rectangle {
            id: popupBackground
            readonly property real padding: 4
            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
                margins: root.padding
            }

            color: Appearance.colors.colBarBg ?? Appearance.colors.colLayer0
            radius: Appearance.rounding.verysmall
            border.width: 1
            border.color: Appearance.colors.colOutlineVariant
            clip: true

            opacity: 0
            Component.onCompleted: opacity = 1
            implicitWidth: stackView.implicitWidth + popupBackground.padding * 2
            implicitHeight: stackView.implicitHeight + popupBackground.padding * 2

            Behavior on opacity {
                NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
            }
            Behavior on implicitHeight {
                NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
            }
            Behavior on implicitWidth {
                NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
            }

            StackView {
                id: stackView
                anchors {
                    fill: parent
                    margins: popupBackground.padding
                }
                pushEnter: NoAnim {}
                pushExit: NoAnim {}
                popEnter: NoAnim {}
                popExit: NoAnim {}

                implicitWidth: currentItem.implicitWidth
                implicitHeight: currentItem.implicitHeight

                initialItem: SubMenu {
                    handle: root.trayItemMenuHandle
                }
            }
        }
    }

    component NoAnim: Transition {
        NumberAnimation { duration: 0 }
    }

    component SubMenu: ColumnLayout {
        id: submenu
        required property QsMenuHandle handle
        property bool isSubMenu: false
        property bool shown: false
        opacity: shown ? 1 : 0

        Behavior on opacity {
            NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
        }

        Component.onCompleted: shown = true
        StackView.onActivating: shown = true
        StackView.onDeactivating: shown = false
        StackView.onRemoved: destroy()

        QsMenuOpener {
            id: menuOpener
            menu: submenu.handle
        }

        spacing: 0

        // Back button for submenus
        Button {
            id: backButton
            Layout.fillWidth: true
            visible: submenu.isSubMenu
            flat: true
            padding: 0
            horizontalPadding: 6
            implicitHeight: 22

            onClicked: stackView.pop()

            background: Rectangle {
                radius: popupBackground.radius - popupBackground.padding
                color: backButton.hovered ? Appearance.colors.colLayer1Hover : "transparent"
            }

            contentItem: RowLayout {
                anchors {
                    verticalCenter: parent.verticalCenter
                    left: parent.left
                    right: parent.right
                    leftMargin: backButton.horizontalPadding
                    rightMargin: backButton.horizontalPadding
                }
                spacing: 4

                Text {
                    text: "\u2039"
                    font.family: "Hack"
                    font.pixelSize: 12
                    color: Appearance.m3colors.m3onSurfaceVariant
                    renderType: Text.NativeRendering
                    verticalAlignment: Text.AlignVCenter
                }
                Text {
                    Layout.fillWidth: true
                    text: "Back"
                    font.family: "Hack"
                    font.pixelSize: 11
                    font.hintingPreference: Font.PreferFullHinting
                    color: Appearance.m3colors.m3onSurfaceVariant
                    renderType: Text.NativeRendering
                    verticalAlignment: Text.AlignVCenter
                }
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                acceptedButtons: Qt.NoButton
            }
        }

        Repeater {
            id: menuEntriesRepeater
            property bool iconColumnNeeded: {
                for (let i = 0; i < menuOpener.children.values.length; i++) {
                    if (menuOpener.children.values[i].icon.length > 0)
                        return true;
                }
                return false;
            }
            property bool specialInteractionColumnNeeded: {
                for (let i = 0; i < menuOpener.children.values.length; i++) {
                    if (menuOpener.children.values[i].buttonType !== QsMenuButtonType.None)
                        return true;
                }
                return false;
            }
            model: menuOpener.children
            delegate: SysTrayMenuEntry {
                required property QsMenuEntry modelData
                forceIconColumn: menuEntriesRepeater.iconColumnNeeded
                forceSpecialInteractionColumn: menuEntriesRepeater.specialInteractionColumnNeeded
                menuEntry: modelData

                buttonRadius: popupBackground.radius - popupBackground.padding

                onDismiss: root.close()
                onOpenSubmenu: handle => {
                    stackView.push(subMenuComponent.createObject(null, {
                        handle: handle,
                        isSubMenu: true
                    }));
                }
            }
        }
    }

    Component {
        id: subMenuComponent
        SubMenu {}
    }
}
