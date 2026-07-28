import QtQuick
import Quickshell
import Quickshell.Wayland
import "../modules/common"
import "../modules/common/widgets"

Scope {
    id: root
    property real borderWidth: 5
    property real cornerSize: Appearance.rounding.verysmall
    property color frameColor: Appearance.colors.colBarBg

    // Left border
    Variants {
        model: Quickshell.screens

        PanelWindow {
            required property var modelData
            screen: modelData
            anchors { top: true; left: true; bottom: true }
            implicitWidth: root.borderWidth
            color: root.frameColor
            exclusionMode: ExclusionMode.Auto
            WlrLayershell.layer: WlrLayer.Top
            WlrLayershell.namespace: "quickshell-frame-left"
        }
    }

    // Right border
    Variants {
        model: Quickshell.screens

        PanelWindow {
            required property var modelData
            screen: modelData
            anchors { top: true; right: true; bottom: true }
            implicitWidth: root.borderWidth
            color: root.frameColor
            exclusionMode: ExclusionMode.Auto
            WlrLayershell.layer: WlrLayer.Top
            WlrLayershell.namespace: "quickshell-frame-right"
        }
    }

    // Corners (overlay on top of everything)
    Variants {
        model: Quickshell.screens

        Scope {
            id: monitorScope
            required property var modelData

            PanelWindow {
                screen: monitorScope.modelData
                anchors { top: true; left: true }
                margins { top: Appearance.sizes.barHeight; left: root.borderWidth }
                implicitWidth: root.cornerSize
                implicitHeight: root.cornerSize
                color: "transparent"
                exclusionMode: ExclusionMode.Ignore
                WlrLayershell.layer: WlrLayer.Overlay
                WlrLayershell.namespace: "quickshell-corner"

                RoundCorner {
                    anchors.fill: parent
                    corner: RoundCorner.CornerEnum.TopLeft
                    implicitSize: root.cornerSize
                    color: root.frameColor
                }
            }

            PanelWindow {
                screen: monitorScope.modelData
                anchors { top: true; right: true }
                margins { top: Appearance.sizes.barHeight; right: root.borderWidth }
                implicitWidth: root.cornerSize
                implicitHeight: root.cornerSize
                color: "transparent"
                exclusionMode: ExclusionMode.Ignore
                WlrLayershell.layer: WlrLayer.Overlay
                WlrLayershell.namespace: "quickshell-corner"

                RoundCorner {
                    anchors.fill: parent
                    corner: RoundCorner.CornerEnum.TopRight
                    implicitSize: root.cornerSize
                    color: root.frameColor
                }
            }

            PanelWindow {
                screen: monitorScope.modelData
                anchors { bottom: true; left: true }
                margins { left: root.borderWidth }
                implicitWidth: root.cornerSize
                implicitHeight: root.cornerSize
                color: "transparent"
                exclusionMode: ExclusionMode.Ignore
                WlrLayershell.layer: WlrLayer.Overlay
                WlrLayershell.namespace: "quickshell-corner"

                RoundCorner {
                    anchors.fill: parent
                    corner: RoundCorner.CornerEnum.BottomLeft
                    implicitSize: root.cornerSize
                    color: root.frameColor
                }
            }

            PanelWindow {
                screen: monitorScope.modelData
                anchors { bottom: true; right: true }
                margins { right: root.borderWidth }
                implicitWidth: root.cornerSize
                implicitHeight: root.cornerSize
                color: "transparent"
                exclusionMode: ExclusionMode.Ignore
                WlrLayershell.layer: WlrLayer.Overlay
                WlrLayershell.namespace: "quickshell-corner"

                RoundCorner {
                    anchors.fill: parent
                    corner: RoundCorner.CornerEnum.BottomRight
                    implicitSize: root.cornerSize
                    color: root.frameColor
                }
            }
        }
    }
}
