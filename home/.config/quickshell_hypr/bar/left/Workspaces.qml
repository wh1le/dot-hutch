import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import "../../modules/common"
import "../../modules/common/functions"
import "../../modules/common/widgets"
import "../../services"

RowLayout {
    id: root
    spacing: 4

    // Same 3 colors as tmux tabs
    readonly property color bgColor: Appearance.m3colors.m3background
    readonly property color fgColor: Appearance.m3colors.m3onBackground
    readonly property color accentColor: Appearance.m3colors.m3primary

    Repeater {
        model: 10

        Item {
            id: ws
            required property int index
            property int wsId: index + 1
            property bool isActive: HyprlandData.activeWorkspace?.id === wsId
            property bool hasWindows: HyprlandData.workspaceIds.includes(wsId)
            property bool isUrgent: false

            visible: true
            opacity: (hasWindows || isActive) ? 1.0 : 0.15
            Layout.alignment: Qt.AlignVCenter
            implicitWidth: 18
            implicitHeight: Appearance.sizes.barHeight

            Text {
                anchors.centerIn: parent
                text: ws.wsId
                font.family: "Hack-ZeroSlash"
                font.pixelSize: 10
                font.weight: ws.isActive ? Font.Bold : Font.Normal
                color: {
                    if (ws.isActive) return root.accentColor;
                    if (ws.hasWindows) return ColorUtils.applyAlpha(root.fgColor, 0.5);
                    return ColorUtils.applyAlpha(root.fgColor, 0.2);
                }
                renderType: Text.NativeRendering
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            // Bottom accent — active only
            Rectangle {
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width
                height: 2
                color: root.accentColor
                visible: ws.isActive
            }

            // Urgent dot
            Rectangle {
                anchors.top: parent.top
                anchors.right: parent.right
                anchors.topMargin: 3
                anchors.rightMargin: 2
                width: 4
                height: 4
                radius: 2
                color: root.accentColor
                visible: ws.isUrgent
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: Hyprland.dispatch(`workspace ${ws.wsId}`)
            }
        }
    }
}
