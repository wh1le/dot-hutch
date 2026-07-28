pragma ComponentBehavior: Bound
import "../../../services"
import "../../../modules/common"
import "../../../modules/common/widgets"
import "../../../modules/common/functions"
import "../../.."
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Mpris

Item {
    id: root
    readonly property var realPlayers: MprisController.players
    readonly property int activeIndex: {
        const active = MprisController.activePlayer;
        if (!active) return 0;
        const idx = realPlayers.indexOf(active);
        return idx >= 0 ? idx : 0;
    }
    property int currentIndex: activeIndex
    implicitWidth: 320
    implicitHeight: 120

    CrossfadeView {
        anchors.fill: parent
        model: root.realPlayers
        currentIndex: root.currentIndex
        delegate: PlayerControl {
            player: parent.modelData
            playerIndex: parent.index
            playerCount: root.realPlayers.length
            currentIndex: root.currentIndex
            onSwitchTo: (idx) => root.currentIndex = idx
            implicitWidth: root.implicitWidth
            implicitHeight: root.implicitHeight
            radius: 0
        }
    }

    // No player placeholder
    Rectangle {
        visible: root.realPlayers.length === 0
        anchors.fill: parent
        color: "transparent"

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

    Component.onCompleted: root.currentIndex = root.activeIndex
}
