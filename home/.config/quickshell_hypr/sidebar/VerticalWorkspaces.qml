pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import Quickshell.Widgets
import "../modules/common"
import "../modules/common/functions"
import "../modules/common/widgets"
import "../services"
import ".."

Rectangle {
    id: root

    readonly property int activeWsId: HyprlandData.activeWorkspace?.id ?? 1
    readonly property var allWorkspaceIds: [1, 2, 3, 4, 5, 6, 7, 8, 9, 0]

    readonly property real tileHeight: 36
    readonly property real iconSize: 8
    readonly property int maxVisibleIcons: 2

    implicitWidth: 30
    color: ColorUtils.applyAlpha(Appearance.colors.colBarBg, 0.95)
    clip: true

    // Right-edge gradient shadow (20px fade)
    Rectangle {
        x: root.width
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: 20
        gradient: Gradient {
            orientation: Gradient.Horizontal
            GradientStop { position: 0.0; color: Qt.rgba(0, 0, 0, 0.25) }
            GradientStop { position: 1.0; color: Qt.rgba(0, 0, 0, 0) }
        }
        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.NoButton
            hoverEnabled: false
        }
    }



    ColumnLayout {
        id: layout
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        spacing: 0

        Repeater {
            id: repeater
            model: root.allWorkspaceIds

            Item {
                id: tile
                required property var modelData
                required property int index
                property int wsId: modelData === 0 ? 10 : modelData
                property int displayNum: modelData
                property bool isActive: root.activeWsId === wsId
                property var windows: HyprlandData.hyprlandClientsForWorkspace(tile.wsId)
                property bool hasWindows: windows.length > 0
                property bool hasOverflow: windows.length > root.maxVisibleIcons
                property var visibleWindows: {
                    var result = [];
                    var limit = Math.min(windows.length, root.maxVisibleIcons);
                    for (var i = 0; i < limit; i++) result.push(windows[i]);
                    return result;
                }

                Layout.fillWidth: true
                Layout.preferredHeight: root.tileHeight

                // Tile background tint
                Rectangle {
                    anchors.fill: parent
                    color: tile.isActive
                        ? Qt.rgba(81/255, 149/255, 172/255, 0.1)
                        : tile.hasWindows ? Qt.rgba(193/255, 194/255, 196/255, 0.03) : "transparent"
                }

                // Left border rail (3px, always visible)
                Rectangle {
                    id: leftBorder
                    anchors.left: parent.left
                    anchors.top: parent.top
                    width: 3
                    height: root.tileHeight
                    color: tile.isActive
                        ? Appearance.colors.colPrimary
                        : ColorUtils.applyAlpha(Appearance.m3colors.m3onBackground, 0.08)
                }

                // Left zone: app icons stacked vertically (16px wide)
                Column {
                    id: leftZone
                    anchors.left: leftBorder.right
                    anchors.leftMargin: 2
                    width: 10
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 1

                    Repeater {
                        model: tile.visibleWindows

                        Item {
                            id: appIconItem
                            required property var modelData
                            width: 10
                            height: root.iconSize

                            IconImage {
                                anchors.centerIn: parent
                                width: root.iconSize
                                height: root.iconSize
                                source: Quickshell.iconPath(AppIcons.guessIcon(appIconItem.modelData.class), "image-missing")
                                opacity: tile.isActive ? 0.85 : 0.5
                            }

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    Hyprland.dispatch("workspace " + tile.wsId);
                                    Hyprland.dispatch("focuswindow address:" + appIconItem.modelData.address);
                                }
                            }
                        }
                    }

                    // Overflow dot
                    Rectangle {
                        visible: tile.hasOverflow
                        width: 4
                        height: 4
                        radius: 2
                        color: Appearance.colors.colPrimary
                        opacity: 0.5
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }

                // Right zone: workspace number
                Text {
                    anchors.left: leftZone.right
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    text: tile.displayNum
                    font.family: "Hack-ZeroSlash"
                    font.pixelSize: 9
                    font.weight: Font.Bold
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    color: {
                        if (tile.isActive)
                            return Appearance.colors.colPrimary;
                        if (tile.hasWindows)
                            return ColorUtils.applyAlpha(Appearance.m3colors.m3onBackground, 0.4);
                        return ColorUtils.applyAlpha(Appearance.m3colors.m3onBackground, 0.1);
                    }
                }

                // Tile separator (bottom border)
                Rectangle {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    height: 1
                    color: ColorUtils.applyAlpha(Appearance.m3colors.m3onBackground, 0.04)
                    visible: tile.index < repeater.count - 1
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    z: -1
                    onClicked: Hyprland.dispatch(`workspace ${tile.wsId}`)
                }
            }
        }
    }
}
