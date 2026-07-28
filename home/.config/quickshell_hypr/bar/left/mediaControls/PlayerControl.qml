pragma ComponentBehavior: Bound
import "../../../modules/common"
import "../../../modules/common/models"
import "../../../modules/common/widgets"
import "../../../modules/common/functions"
import "../../../services"
import Qt5Compat.GraphicalEffects
import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Mpris

Item {
    id: root
    required property MprisPlayer player
    property var artUrl: player?.trackArtUrl ?? ""
    readonly property string playerAppName: {
        const name = player?.dbusName ?? "";
        // Extract app name from org.mpris.MediaPlayer2.appname.instanceXXX
        const parts = name.replace(/\.instance\d+$/, '').split('.');
        return parts[parts.length - 1] || "";
    }
    property color artDominantColor: Appearance.colors.colPrimaryContainer
    property real radius
    property int playerIndex: 0
    property int playerCount: 1
    property int currentIndex: 0
    signal switchTo(int index)

    Timer {
        running: root.player?.playbackState == MprisPlaybackState.Playing
        interval: 1000
        repeat: true
        onTriggered: root.player.positionChanged()
    }

    component IconToggle: MouseArea {
        property string iconName
        property bool active: false
        property real size: 20
        property real iconPixelSize: 14
        property color activeColor: blendedColors.colPrimary
        property color inactiveColor: blendedColors.colSubtext
        implicitWidth: size
        implicitHeight: size
        cursorShape: Qt.PointingHandCursor
        MaterialSymbol {
            anchors.centerIn: parent
            iconSize: parent.iconPixelSize
            fill: 1
            text: parent.iconName
            color: parent.active ? parent.activeColor : parent.inactiveColor
        }
    }

    property QtObject blendedColors: AdaptedMaterialScheme {
        color: artDominantColor
    }

    Rectangle {
        id: background
        anchors.fill: parent
        color: "transparent"
        topLeftRadius: 0
        topRightRadius: 0
        bottomLeftRadius: 0
        bottomRightRadius: Appearance.rounding.verysmall

        layer.enabled: true
        layer.effect: OpacityMask {
            maskSource: Rectangle {
                width: background.width
                height: background.height
                topLeftRadius: 0
                topRightRadius: 0
                bottomLeftRadius: 0
                bottomRightRadius: Appearance.rounding.verysmall
            }
        }

        Image {
            id: blurredArt
            anchors.fill: parent
            source: root.artUrl
            sourceSize.width: background.width
            sourceSize.height: background.height
            fillMode: Image.PreserveAspectCrop
            visible: status === Image.Ready
            asynchronous: true

            layer.enabled: true
            layer.effect: MultiEffect {
                source: blurredArt
                saturation: -0.3
                blurEnabled: true
                blurMax: 100
                blur: 1
            }

            Rectangle {
                anchors.fill: parent
                color: ColorUtils.transparentize(Appearance.colors.colBarBg, 0.35)
            }
        }

        // Full-surface edge fades — gradual opacity across entire width/height
        Rectangle {
            anchors.fill: parent
            gradient: Gradient {
                orientation: Gradient.Horizontal
                GradientStop { position: 0.0; color: Appearance.colors.colBarBg }
                GradientStop { position: 0.08; color: "transparent" }
                GradientStop { position: 0.55; color: "transparent" }
                GradientStop { position: 1.0; color: Appearance.colors.colBarBg }
            }
        }
        Rectangle {
            anchors.fill: parent
            gradient: Gradient {
                GradientStop { position: 0.0; color: Appearance.colors.colBarBg }
                GradientStop { position: 0.15; color: "transparent" }
                GradientStop { position: 0.8; color: "transparent" }
                GradientStop { position: 1.0; color: Appearance.colors.colBarBg }
            }
        }

        RowLayout {
            anchors.fill: parent
            anchors.margins: 8
            spacing: 8

            // Album art with faded edges
            Item {
                id: artBackground
                Layout.fillHeight: true
                implicitWidth: height

                property bool useA: true
                property string lastArtUrl: ""

                FadedImage {
                    id: artImageA
                    anchors.fill: parent
                    fillMode: Image.PreserveAspectCrop
                    asynchronous: true
                    sourceSize: Qt.size(800, 800)
                    smooth: true
                    mipmap: true
                    cache: false
                    fadeRight: 0.35
                    fadeBottom: 0.15
                    opacity: 1
                    Behavior on opacity { NumberAnimation { duration: 200 } }
                }
                FadedImage {
                    id: artImageB
                    anchors.fill: parent
                    fillMode: Image.PreserveAspectCrop
                    asynchronous: true
                    sourceSize: Qt.size(800, 800)
                    smooth: true
                    mipmap: true
                    cache: false
                    fadeRight: 0.35
                    fadeBottom: 0.15
                    opacity: 0
                    Behavior on opacity { NumberAnimation { duration: 200 } }
                }

                Connections {
                    target: root
                    function onArtUrlChanged() {
                        if (root.artUrl === artBackground.lastArtUrl) return;
                        artBackground.lastArtUrl = root.artUrl;
                        if (artBackground.useA) {
                            artImageA.source = root.artUrl;
                            artImageA.opacity = 1;
                            artImageB.opacity = 0;
                        } else {
                            artImageB.source = root.artUrl;
                            artImageB.opacity = 1;
                            artImageA.opacity = 0;
                        }
                        artBackground.useA = !artBackground.useA;
                    }
                }
                Component.onCompleted: { artImageA.source = root.artUrl; lastArtUrl = root.artUrl; }

                // Fallback: subtle background when no art available
                Rectangle {
                    anchors.fill: parent
                    color: ColorUtils.mix(Appearance.colors.colBarBg, Appearance.colors.colOnLayer0, 0.9)
                    visible: !root.artUrl || root.artUrl === ""
                }
            }

            // Right side: title, artist, time+controls, slider
            ColumnLayout {
                Layout.fillHeight: true
                Layout.fillWidth: true
                spacing: 2

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 2

                    StyledText {
                        Layout.fillWidth: true
                        font.pixelSize: Appearance.font.pixelSize.small
                        color: blendedColors.colOnLayer0
                        elide: Text.ElideRight
                        text: StringUtils.cleanMusicTitle(root.player?.trackTitle) || "Untitled"
                    }

                    // Shuffle button (mpv only)
                    IconToggle {
                        visible: root.player?.shuffleSupported ?? false
                        iconName: "shuffle"
                        active: root.player?.shuffle ?? false
                        activeColor: blendedColors.colOnLayer0
                        inactiveColor: ColorUtils.transparentize(blendedColors.colSubtext, 0.4)
                        onClicked: root.player.shuffle = !root.player.shuffle
                    }

                    // Loop button (mpv only): None -> Playlist -> Track -> None
                    IconToggle {
                        visible: root.player?.loopSupported ?? false
                        iconName: root.player?.loopState === MprisLoopState.Track ? "repeat_one" : "repeat"
                        active: root.player?.loopState !== MprisLoopState.None
                        activeColor: blendedColors.colOnLayer0
                        inactiveColor: ColorUtils.transparentize(blendedColors.colSubtext, 0.4)
                        onClicked: {
                            if (root.player.loopState === MprisLoopState.None)
                                root.player.loopState = MprisLoopState.Playlist;
                            else if (root.player.loopState === MprisLoopState.Playlist)
                                root.player.loopState = MprisLoopState.Track;
                            else
                                root.player.loopState = MprisLoopState.None;
                        }
                    }
                }

                StyledText {
                    Layout.fillWidth: true
                    font.pixelSize: Appearance.font.pixelSize.smallest
                    color: blendedColors.colSubtext
                    elide: Text.ElideRight
                    text: root.player?.trackArtist ?? ""
                }

                Item { Layout.fillHeight: true; Layout.maximumHeight: 4 }

                // Time + controls row
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 4

                    StyledText {
                        font.pixelSize: Appearance.font.pixelSize.smallest
                        color: blendedColors.colSubtext
                        text: StringUtils.friendlyTimeForSeconds(root.player?.position)
                    }

                    Item { Layout.fillWidth: true }

                    IconToggle {
                        iconName: "skip_previous"
                        active: true
                        activeColor: blendedColors.colOnSecondaryContainer
                        size: 22
                        iconPixelSize: Appearance.font.pixelSize.large
                        onClicked: root.player?.previous()
                    }

                    IconToggle {
                        iconName: root.player?.isPlaying ? "pause" : "play_arrow"
                        active: true
                        activeColor: blendedColors.colOnSecondaryContainer
                        size: 24
                        iconPixelSize: Appearance.font.pixelSize.huge
                        onClicked: root.player?.togglePlaying()
                    }

                    IconToggle {
                        iconName: "skip_next"
                        active: true
                        activeColor: blendedColors.colOnSecondaryContainer
                        size: 22
                        iconPixelSize: Appearance.font.pixelSize.large
                        onClicked: root.player?.next()
                    }

                    Item { Layout.fillWidth: true }

                    StyledText {
                        font.pixelSize: Appearance.font.pixelSize.smallest
                        color: blendedColors.colSubtext
                        text: StringUtils.friendlyTimeForSeconds(root.player?.length)
                    }
                }

                // Slider
                Item {
                    Layout.fillWidth: true
                    implicitHeight: 12

                    Loader {
                        id: sliderLoader
                        anchors.fill: parent
                        active: root.player?.canSeek ?? false
                        sourceComponent: StyledSlider {
                            highlightColor: blendedColors.colPrimary
                            trackColor: blendedColors.colSecondaryContainer
                            handleColor: blendedColors.colPrimary
                            trackWidth: 3
                            trackRadius: 1.5
                            handleDefaultWidth: 8
                            handlePressedWidth: 10
                            handleHeight: 8
                            handleMargins: 0
                            value: (root.player?.length > 0) ? root.player.position / root.player.length : 0
                            onMoved: root.player.position = value * root.player.length
                        }
                    }

                    Loader {
                        id: progressBarLoader
                        anchors { verticalCenter: parent.verticalCenter; left: parent.left; right: parent.right }
                        active: !(root.player?.canSeek ?? false)
                        sourceComponent: StyledProgressBar {
                            highlightColor: blendedColors.colPrimary
                            trackColor: blendedColors.colSecondaryContainer
                            value: (root.player?.length > 0) ? root.player.position / root.player.length : 0
                        }
                    }
                }
            }
        }

        // Source dots (top right, similar to workspace indicators)
        Row {
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.topMargin: 6
            anchors.rightMargin: 8
            spacing: 5
            visible: root.playerCount > 1
            z: 10

            Repeater {
                model: root.playerCount

                Rectangle {
                    required property int index
                    width: root.currentIndex === index ? 16 : 7
                    height: 7
                    radius: 3.5
                    color: root.currentIndex === index
                        ? Appearance.colors.colOnLayer0
                        : ColorUtils.transparentize(Appearance.colors.colOnLayer0, 0.6)

                    Behavior on width {
                        NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
                    }
                    Behavior on color {
                        animation: Appearance.animation.elementMoveFast.colorAnimation.createObject(this)
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.switchTo(index)
                    }
                }
            }
        }
    }
}
