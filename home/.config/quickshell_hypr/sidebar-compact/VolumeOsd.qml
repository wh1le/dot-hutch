pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Pipewire
import "../modules/common"
import "../modules/common/widgets"
import "../modules/common/functions"
import "../services"
import ".."

Item {
    id: root

    anchors {
        right: parent.right
        verticalCenter: parent.verticalCenter
    }

    property bool osdVisible: false
    property bool osdPaused: false

    onOsdVisibleChanged: GlobalStates.volumeOsdVisible = osdVisible

    Connections {
        target: GlobalStates
        function onVolumeOsdVisibleChanged() {
            if (!GlobalStates.volumeOsdVisible) root.osdVisible = false;
        }
    }

    implicitWidth: osdVisible ? 36 : 0
    implicitHeight: 160

    Behavior on implicitWidth {
        NumberAnimation {
            duration: Appearance.animation.elementMove.duration
            easing.type: Appearance.animation.elementMove.type
            easing.bezierCurve: Appearance.animation.elementMove.bezierCurve
        }
    }

    clip: true

    Connections {
        target: Audio.sink?.audio ?? null
        function onVolumeChanged() {
            if (!Audio.ready) return;
            root.showOsd();
            iconBounce.restart();
        }
        function onMutedChanged() {
            if (!Audio.ready) return;
            root.showOsd();
            iconBounce.restart();
        }
    }

    function showOsd() {
        GlobalStates.brightnessOsdVisible = false;
        osdVisible = true;
        if (!osdPaused) hideTimer.restart();
    }

    Timer {
        id: hideTimer
        interval: 2000
        onTriggered: if (!root.osdPaused) root.osdVisible = false
    }

    Rectangle {
        id: panel
        anchors.fill: parent
        color: Appearance.colors.colBarBg
        topLeftRadius: Appearance.rounding.verysmall
        bottomLeftRadius: Appearance.rounding.verysmall

        // Panel fade in/out
        opacity: root.osdVisible ? 1 : 0
        Behavior on opacity {
            NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.topMargin: 10
            anchors.bottomMargin: 10
            spacing: 6

            Item {
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: 24
                Layout.preferredHeight: 24

                MaterialSymbol {
                    id: volIcon
                    anchors.centerIn: parent
                    iconSize: 16
                    fill: 1
                    text: {
                        if (Audio.sink?.audio.muted) return "volume_off";
                        let v = Audio.value;
                        return v < 0.01 ? "volume_mute" : v < 0.33 ? "volume_down" : "volume_up";
                    }
                    color: Audio.sink?.audio.muted ? Appearance.m3colors.m3outline : Appearance.m3colors.m3primary

                    // Bounce animation on change
                    scale: 1.0
                    SequentialAnimation {
                        id: iconBounce
                        NumberAnimation { target: volIcon; property: "scale"; to: 1.3; duration: 100; easing.type: Easing.OutQuad }
                        NumberAnimation { target: volIcon; property: "scale"; to: 1.0; duration: 200; easing.type: Easing.OutBounce }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: Audio.toggleMute()
                }
            }

            Slider {
                id: slider
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: 20
                Layout.fillHeight: true
                orientation: Qt.Vertical
                from: 0; to: 1
                value: Pipewire.defaultAudioSink?.audio.volume ?? 0
                hoverEnabled: true

                onMoved: Pipewire.defaultAudioSink.audio.volume = value
                onPressedChanged: {
                    if (pressed) {
                        root.osdPaused = true; hideTimer.stop();
                    } else {
                        root.osdPaused = false; hideTimer.restart();
                    }
                }

                readonly property real barW: 10

                MouseArea {
                    anchors.fill: parent
                    cursorShape: slider.pressed ? Qt.ClosedHandCursor : Qt.PointingHandCursor
                    onPressed: mouse => {
                        var p = 1 - ((mouse.y - slider.topPadding) / slider.availableHeight);
                        slider.value = Math.max(0, Math.min(1, p));
                        mouse.accepted = false;
                    }
                }

                background: Item {
                    width: slider.availableWidth
                    height: slider.availableHeight
                    x: slider.leftPadding
                    y: slider.topPadding

                    Rectangle {
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        width: slider.barW
                        radius: slider.barW / 2
                        color: Qt.lighter(Appearance.colors.colBarBg, 1.3)
                    }

                    Rectangle {
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.bottom: parent.bottom
                        width: slider.barW
                        height: Math.max(0, parent.height * (1 - slider.visualPosition))
                        radius: slider.barW / 2
                        color: Audio.sink?.audio.muted ? Appearance.m3colors.m3outline : Appearance.m3colors.m3primary

                        Behavior on height {
                            NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
                        }
                        Behavior on color {
                            ColorAnimation { duration: 200 }
                        }
                    }
                }

                handle: Item { width: 0; height: 0; visible: false }
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        propagateComposedEvents: true
        acceptedButtons: Qt.NoButton
        onEntered: { root.osdPaused = true; hideTimer.stop(); }
        onExited: { root.osdPaused = false; hideTimer.restart(); }
    }
}
