import "../../modules/common"
import "../../modules/common/widgets"
import "../../modules/common/functions"
import "../../services"
import "../.."

import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import Qt5Compat.GraphicalEffects
import Quickshell
import Quickshell.Services.Mpris

Item {
    id: root
    readonly property MprisPlayer activePlayer: MprisController.activePlayer
    readonly property string trackTitle: StringUtils.cleanMusicTitle(activePlayer?.trackTitle) || ""
    readonly property string trackArtist: activePlayer?.trackArtist ?? ""
    readonly property string artUrl: activePlayer?.trackArtUrl ?? ""

    property real toastWidth: 230
    property real toastHeight: 56
    property bool toastVisible: false

    onToastVisibleChanged: GlobalStates.mediaToastVisible = toastVisible

    width: toastWidth
    height: toastVisible ? toastHeight : 0
    clip: true

    Behavior on height {
        NumberAnimation {
            duration: 300
            easing.type: Easing.OutCubic
        }
    }

    // Track song changes
    property string _lastTitle: ""
    onTrackTitleChanged: {
        if (trackTitle === "" || trackTitle === _lastTitle) return;
        if (_lastTitle === "") {
            _lastTitle = trackTitle;
            return;
        }
        _lastTitle = trackTitle;
        if (GlobalStates.mediaControlsOpen || GlobalStates.quickSettingsOpen) return;
        // Only toast for actual track switches while playing, not metadata
        // churn while browsing (e.g. paused YouTube tab updating its title)
        if (!activePlayer?.isPlaying) return;
        // Only show toast for players that provide album art
        if (!artUrl || artUrl === "") return;
        showToast();
    }

    function showToast() {
        toastVisible = true;
        hideTimer.restart();
    }

    // Close toast when popups open
    Connections {
        target: GlobalStates
        function onMediaControlsOpenChanged() { if (GlobalStates.mediaControlsOpen) root.toastVisible = false; }
        function onQuickSettingsOpenChanged() { if (GlobalStates.quickSettingsOpen) root.toastVisible = false; }
    }

    Timer {
        id: hideTimer
        interval: 2500
        onTriggered: root.toastVisible = false
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: hideTimer.stop()
        onExited: hideTimer.restart()
    }

    // Glow behind the toast
    RectangularGlow {
        anchors.fill: toastBg
        glowRadius: 10
        spread: 0.05
        color: ColorUtils.transparentize(Appearance.m3colors.m3primary, 0.82)
        cornerRadius: toastBg.bottomLeftRadius + glowRadius
        opacity: root.toastVisible ? 1 : 0
        Behavior on opacity {
            NumberAnimation { duration: 400; easing.type: Easing.OutCubic }
        }
    }

    Rectangle {
        id: toastBg
        width: root.toastWidth
        height: root.toastHeight
        color: Appearance.colors.colBarBg
        topLeftRadius: 0
        topRightRadius: 0
        bottomLeftRadius: Appearance.rounding.verysmall
        bottomRightRadius: Appearance.rounding.verysmall
        border.width: 0

        layer.enabled: true
        layer.effect: OpacityMask {
            maskSource: Rectangle {
                width: toastBg.width
                height: toastBg.height
                topLeftRadius: 0
                topRightRadius: 0
                bottomLeftRadius: Appearance.rounding.verysmall
                bottomRightRadius: Appearance.rounding.verysmall
            }
        }

        // Blurred album art background
        Image {
            id: blurredArt
            anchors.fill: parent
            source: root.artUrl
            sourceSize.width: parent.width
            sourceSize.height: parent.height
            fillMode: Image.PreserveAspectCrop
            visible: status === Image.Ready
            asynchronous: true

            layer.enabled: true
            layer.effect: MultiEffect {
                source: blurredArt
                saturation: -0.4
                blurEnabled: true
                blurMax: 80
                blur: 1
            }

            Rectangle {
                anchors.fill: parent
                color: ColorUtils.transparentize(Appearance.colors.colBarBg, 0.25)
            }
        }

        // Edge fades
        Rectangle {
            anchors.fill: parent
            gradient: Gradient {
                orientation: Gradient.Horizontal
                GradientStop { position: 0.0; color: Appearance.colors.colBarBg }
                GradientStop { position: 0.06; color: "transparent" }
                GradientStop { position: 0.55; color: "transparent" }
                GradientStop { position: 1.0; color: Appearance.colors.colBarBg }
            }
        }
        Rectangle {
            anchors.fill: parent
            gradient: Gradient {
                GradientStop { position: 0.0; color: Appearance.colors.colBarBg }
                GradientStop { position: 0.12; color: "transparent" }
                GradientStop { position: 0.75; color: "transparent" }
                GradientStop { position: 1.0; color: Appearance.colors.colBarBg }
            }
        }

        // Album art with rounded corners
        Rectangle {
            id: artContainer
            x: 6
            y: 5
            width: root.toastHeight - 10
            height: root.toastHeight - 10
            radius: Appearance.rounding.verysmall - 2
            color: ColorUtils.mix(Appearance.colors.colBarBg, Appearance.colors.colOnLayer0, 0.92)
            clip: true

            Image {
                anchors.fill: parent
                source: root.artUrl
                fillMode: Image.PreserveAspectCrop
                sourceSize: Qt.size(96, 96)
                smooth: true
                mipmap: true
                visible: status === Image.Ready
            }
        }

        // Title + Artist
        ColumnLayout {
            anchors.left: artContainer.right
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.leftMargin: 8
            anchors.rightMargin: 8
            spacing: 2

            Item { Layout.fillHeight: true }

            StyledText {
                Layout.fillWidth: true
                font.pixelSize: Appearance.font.pixelSize.smaller
                color: Appearance.colors.colOnLayer0
                elide: Text.ElideRight
                text: root.trackTitle || "Untitled"
            }

            StyledText {
                Layout.fillWidth: true
                font.pixelSize: Appearance.font.pixelSize.smallest
                color: Appearance.colors.colSubtext
                elide: Text.ElideRight
                text: root.trackArtist
                visible: root.trackArtist !== ""
            }

            Item { Layout.fillHeight: true }
        }

        // Subtle bottom/right border
        Rectangle {
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: 1
            color: ColorUtils.transparentize(Appearance.colors.colOnLayer0, 0.9)
        }
        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: 1
            color: ColorUtils.transparentize(Appearance.colors.colOnLayer0, 0.9)
        }

        // Content fade-in
        opacity: root.toastVisible ? 1 : 0
        Behavior on opacity {
            NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
        }
    }
}
