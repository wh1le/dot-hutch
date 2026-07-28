pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import "../../modules/common"
import "../../modules/common/widgets"

Button {
    id: root
    required property QsMenuEntry menuEntry
    property bool forceIconColumn: false
    property bool forceSpecialInteractionColumn: false
    property real buttonRadius: Appearance.rounding.verysmall
    readonly property bool hasIcon: menuEntry.icon.length > 0
    readonly property bool hasSpecialInteraction: menuEntry.buttonType !== QsMenuButtonType.None

    signal dismiss()
    signal openSubmenu(handle: QsMenuHandle)

    enabled: !menuEntry.isSeparator
    opacity: 1
    flat: true
    padding: 0
    horizontalPadding: 6
    implicitWidth: contentItem.implicitWidth + horizontalPadding * 2
    implicitHeight: menuEntry.isSeparator ? 1 : 22
    Layout.topMargin: menuEntry.isSeparator ? 2 : 0
    Layout.bottomMargin: menuEntry.isSeparator ? 2 : 0
    Layout.fillWidth: true

    onClicked: {
        if (menuEntry.hasChildren) {
            root.openSubmenu(root.menuEntry);
            return;
        }
        menuEntry.triggered();
        root.dismiss();
    }

    background: Rectangle {
        radius: root.buttonRadius
        color: menuEntry.isSeparator ? Appearance.colors.colOutlineVariant
            : root.hovered ? Appearance.colors.colLayer1Hover
            : "transparent"

        Behavior on color {
            ColorAnimation { duration: 100 }
        }
    }

    contentItem: RowLayout {
        anchors {
            verticalCenter: parent.verticalCenter
            left: parent.left
            right: parent.right
            leftMargin: root.horizontalPadding
            rightMargin: root.horizontalPadding
        }
        spacing: 4
        visible: !root.menuEntry.isSeparator

        // Checkbox / Radio
        Item {
            visible: root.hasSpecialInteraction || root.forceSpecialInteractionColumn
            implicitWidth: 12
            implicitHeight: 12

            // Checkbox
            Rectangle {
                anchors.centerIn: parent
                width: 11
                height: 11
                radius: 3
                visible: root.menuEntry.buttonType === QsMenuButtonType.CheckBox
                color: root.menuEntry.checkState !== Qt.Unchecked ? Appearance.m3colors.m3primary : "transparent"
                border.width: 1.5
                border.color: root.menuEntry.checkState !== Qt.Unchecked ? Appearance.m3colors.m3primary : Appearance.colors.colOutline

                Text {
                    anchors.centerIn: parent
                    text: root.menuEntry.checkState === Qt.PartiallyChecked ? "\u2013" : "\u2713"
                    font.pixelSize: 8
                    font.bold: true
                    color: Appearance.m3colors.m3onPrimary
                    visible: root.menuEntry.checkState !== Qt.Unchecked
                    renderType: Text.NativeRendering
                }
            }

            // Radio
            Rectangle {
                anchors.centerIn: parent
                width: 11
                height: 11
                radius: 6
                visible: root.menuEntry.buttonType === QsMenuButtonType.RadioButton
                color: "transparent"
                border.width: 1.5
                border.color: root.menuEntry.checkState === Qt.Checked ? Appearance.m3colors.m3primary : Appearance.colors.colOutline

                Rectangle {
                    anchors.centerIn: parent
                    width: 6
                    height: 6
                    radius: 3
                    color: Appearance.m3colors.m3primary
                    visible: root.menuEntry.checkState === Qt.Checked
                }
            }
        }

        // Icon
        Item {
            visible: root.hasIcon || root.forceIconColumn
            implicitWidth: 12
            implicitHeight: 12

            Loader {
                anchors.centerIn: parent
                active: root.menuEntry.icon.length > 0
                sourceComponent: IconImage {
                    asynchronous: true
                    source: root.menuEntry.icon
                    implicitSize: 12
                    mipmap: true
                }
            }
        }

        // Label
        Text {
            Layout.fillWidth: true
            text: root.menuEntry.text
            font.family: "Hack"
            font.pixelSize: 11
            font.hintingPreference: Font.PreferFullHinting
            color: root.menuEntry.enabled ? Appearance.m3colors.m3onSurfaceVariant : Appearance.colors.colOnLayer1Inactive
            renderType: Text.NativeRendering
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }

        // Submenu arrow
        Text {
            visible: root.menuEntry.hasChildren
            text: "\u203A"
            font.family: "Hack"
            font.pixelSize: 14
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
