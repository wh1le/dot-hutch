import "../../modules/common"
import "../../modules/common/widgets"
import "../../modules/common/functions"
import "../../services"
import "../.."

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Mpris

MouseArea {
    id: root
    readonly property MprisPlayer activePlayer: MprisController.activePlayer
    readonly property string playerIcon: {
        const entry = activePlayer?.desktopEntry ?? "";
        if (entry) return AppIcons.guessIcon(entry);
        return "music-note";
    }
    readonly property string cleanedTitle: StringUtils.cleanMusicTitle(activePlayer?.trackTitle) || "No media"

    implicitWidth: rowLayout.implicitWidth
    implicitHeight: rowLayout.implicitHeight

    cursorShape: Qt.PointingHandCursor
    acceptedButtons: Qt.LeftButton | Qt.MiddleButton | Qt.RightButton | Qt.BackButton | Qt.ForwardButton
    onClicked: (event) => {
        if (event.button === Qt.MiddleButton) {
            activePlayer?.togglePlaying();
        } else if (event.button === Qt.BackButton) {
            activePlayer?.previous();
        } else if (event.button === Qt.ForwardButton) {
            activePlayer?.next();
        } else if (event.button === Qt.RightButton) {
            const players = MprisController.players;
            if (players.length > 1) {
                const currentIdx = players.indexOf(MprisController.activePlayer);
                const nextIdx = (currentIdx + 1) % players.length;
                MprisController.trackedPlayer = players[nextIdx];
            }
        } else if (event.button === Qt.LeftButton) {
            GlobalStates.mediaControlsOpen = !GlobalStates.mediaControlsOpen
        }
    }

    Timer {
        running: activePlayer?.playbackState == MprisPlaybackState.Playing
        interval: 3000
        repeat: true
        onTriggered: activePlayer.positionChanged()
    }

    RowLayout {
        id: rowLayout
        spacing: 8
        anchors.centerIn: parent

        // Track text only — no icon
        Text {
            Layout.alignment: Qt.AlignVCenter
            Layout.maximumWidth: 160
            elide: Text.ElideRight
            font.family: "Hack-ZeroSlash"
            font.pixelSize: 10
            font.weight: Font.Normal
            color: ColorUtils.applyAlpha(Appearance.m3colors.m3onBackground, 0.5)
            text: `${cleanedTitle}${activePlayer?.trackArtist ? ' \u2022 ' + activePlayer.trackArtist : ''}`
        }
    }
}
