pragma ComponentBehavior: Bound
import "../../../services"
import "../../../modules/common"
import "../../../modules/common/widgets"
import "../../../modules/common/functions"
import "../../.."
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Mpris
import Quickshell.Wayland

Scope {
    id: root
    readonly property var realPlayers: Mpris.players.values
    readonly property real widgetWidth: 320
    readonly property real widgetHeight: 120
    readonly property real sidebarWidth: 5

    Variants {
        model: GlobalStates.mediaControlsOpen ? [1] : []

        PanelWindow {
            id: panelWindow
            exclusionMode: ExclusionMode.Ignore
            exclusiveZone: 0
            implicitWidth: root.widgetWidth
            implicitHeight: root.widgetHeight
            color: "transparent"
            WlrLayershell.namespace: "quickshell:mediaControls"
            WlrLayershell.layer: WlrLayer.Overlay

            anchors { top: true; left: true }
            margins {
                top: Appearance.sizes.barHeight + 4
                left: 6
            }

            SwipeView {
                id: swipeView
                anchors.fill: parent
                clip: true
                orientation: Qt.Vertical
                interactive: false

                contentItem: ListView {
                    model: swipeView.contentModel
                    orientation: ListView.Vertical
                    snapMode: ListView.SnapOneItem
                    boundsBehavior: Flickable.StopAtBounds
                    highlightMoveDuration: 400
                    highlightRangeMode: ListView.StrictlyEnforceRange
                    currentIndex: swipeView.currentIndex
                }

                Repeater {
                    model: root.realPlayers

                    PlayerControl {
                        required property var modelData
                        player: modelData
                        playerIndex: SwipeView.index
                        playerCount: root.realPlayers.length
                        currentIndex: swipeView.currentIndex
                        onSwitchTo: (idx) => swipeView.currentIndex = idx
                        implicitWidth: root.widgetWidth
                        implicitHeight: root.widgetHeight
                        radius: Appearance.rounding.verysmall
                    }
                }
            }

            // No player placeholder
            Rectangle {
                visible: root.realPlayers.length === 0
                anchors.fill: parent
                color: Appearance.colors.colLayer1
                radius: Appearance.rounding.verysmall

                ColumnLayout {
                    anchors.centerIn: parent
                    StyledText {
                        text: "No active player"
                        font.pixelSize: Appearance.font.pixelSize.large
                    }
                    StyledText {
                        color: Appearance.colors.colSubtext
                        text: "Play something to see controls here"
                        font.pixelSize: Appearance.font.pixelSize.small
                    }
                }
            }
        }
    }
}
