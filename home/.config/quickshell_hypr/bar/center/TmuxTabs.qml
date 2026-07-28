pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import "../../modules/common"
import "../../modules/common/functions"
import "../../services"

Item {
    id: root
    visible: TmuxService.available
    implicitWidth: container.implicitWidth
    implicitHeight: parent ? parent.height : Appearance.sizes.barHeight

    // 3 pywal colors only
    readonly property color bgColor: Appearance.m3colors.m3background
    readonly property color fgColor: Appearance.m3colors.m3onBackground
    readonly property color accentColor: Appearance.m3colors.m3primary

    Rectangle {
        id: container
        anchors.verticalCenter: parent.verticalCenter
        implicitWidth: tabRow.implicitWidth + 8
        implicitHeight: Appearance.sizes.barHeight - 4
        radius: 4
        color: ColorUtils.lighten(root.bgColor, 0.05)

        RowLayout {
            id: tabRow
            anchors.centerIn: parent
            spacing: 4

            // Session name
            Text {
                text: TmuxService.sessionName
                font.family: "Hack-ZeroSlash"
                font.pixelSize: 10
                font.weight: Font.Bold
                color: ColorUtils.applyAlpha(root.fgColor, 0.35)
                Layout.alignment: Qt.AlignVCenter
                Layout.leftMargin: 4

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    acceptedButtons: Qt.LeftButton
                    onClicked: {}
                }
            }

            // Gap between session name and tabs
            Item { implicitWidth: 12; implicitHeight: 1 }

            // Window tabs
            Repeater {
                model: TmuxService.windows

                Item {
                    id: tab
                    required property var modelData
                    required property int index

                    property bool isActive: modelData.active === 1 || modelData.active === true
                    property bool hasAlert: false // Only show for bell alerts, not activity

                    Layout.alignment: Qt.AlignVCenter
                    Layout.maximumWidth: 160
                    implicitWidth: Math.min(tabContent.implicitWidth + 16, 160)
                    implicitHeight: container.implicitHeight

                    // Bottom accent border — active only
                    Rectangle {
                        anchors.bottom: parent.bottom
                        anchors.left: parent.left
                        anchors.right: parent.right
                        height: 2
                        color: root.accentColor
                        visible: tab.isActive
                    }

                    RowLayout {
                        id: tabContent
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.leftMargin: 8
                        anchors.rightMargin: 8
                        spacing: 4

                        // Index number — small, dim
                        Text {
                            text: tab.modelData.index
                            font.family: "Hack-ZeroSlash"
                            font.pixelSize: 8
                            font.weight: Font.Normal
                            color: ColorUtils.applyAlpha(root.fgColor, 0.2)
                        }

                        // Window name
                        Text {
                            text: tab.modelData.name
                            font.family: "Hack-ZeroSlash"
                            font.pixelSize: 10
                            font.weight: Font.Normal
                            color: tab.isActive
                                ? root.fgColor
                                : ColorUtils.applyAlpha(root.fgColor, 0.5)
                            Layout.maximumWidth: 100
                            elide: Text.ElideRight
                        }

                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        acceptedButtons: Qt.LeftButton | Qt.MiddleButton
                        onClicked: function(mouse) {
                            if (mouse.button === Qt.MiddleButton)
                                TmuxService.killWindow(tab.modelData.index);
                            else
                                TmuxService.selectWindow(tab.modelData.index);
                        }
                    }
                }
            }
        }
    }
}
