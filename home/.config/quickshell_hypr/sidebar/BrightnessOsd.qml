pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import "../modules/common"
import "../modules/common/widgets"
import "../modules/common/functions"
import ".."

Item {
    id: root

    anchors {
        right: parent.right
        verticalCenter: parent.verticalCenter
    }

    property bool osdVisible: false
    property bool osdPaused: false
    property int brightness: -1

    onOsdVisibleChanged: GlobalStates.brightnessOsdVisible = osdVisible

    Connections {
        target: GlobalStates
        function onBrightnessOsdVisibleChanged() {
            if (!GlobalStates.brightnessOsdVisible) root.osdVisible = false;
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

    // Poll brightness
    Process {
        id: pollProc
        command: ["brightnessctl", "info", "-m"]
        stdout: StdioCollector {
            id: brightnessCollector
            onStreamFinished: {
                let output = brightnessCollector.text;
                let match = output.match(/,(\d+)%,/);
                if (match) {
                    let percent = parseInt(match[1]);
                    if (percent !== root.brightness) {
                        let isFirst = root.brightness < 0;
                        root.brightness = percent;
                        if (!isFirst) {
                            root.showOsd();
                            iconBounce.restart();
                            brightIcon.rotation = brightIcon.rotation + 15;
                        }
                    }
                }
            }
        }
    }

    Timer {
        interval: 150
        running: true
        repeat: true
        onTriggered: pollProc.running = true
    }

    Component.onCompleted: pollProc.running = true

    Process {
        id: brightnessSetProc
        running: false
    }

    function showOsd() {
        GlobalStates.volumeOsdVisible = false;
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
                    id: brightIcon
                    anchors.centerIn: parent
                    iconSize: 16
                    fill: 1
                    text: root.brightness < 30 ? "dark_mode" : "light_mode"
                    color: Appearance.m3colors.m3tertiary

                    scale: 1.0
                    SequentialAnimation {
                        id: iconBounce
                        NumberAnimation { target: brightIcon; property: "scale"; to: 1.3; duration: 100; easing.type: Easing.OutQuad }
                        NumberAnimation { target: brightIcon; property: "scale"; to: 1.0; duration: 200; easing.type: Easing.OutBounce }
                    }

                    // Rotate icon on brightness change
                    rotation: 0
                    Behavior on rotation {
                        NumberAnimation { duration: 300; easing.type: Easing.OutCubic }
                    }
                }
            }

            Slider {
                id: slider
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: 20
                Layout.fillHeight: true
                orientation: Qt.Vertical
                from: 0; to: 1
                value: root.brightness >= 0 ? root.brightness / 100 : 0
                hoverEnabled: true

                onMoved: {
                    let percent = Math.round(slider.value * 100);
                    brightnessSetProc.running = false;
                    brightnessSetProc.command = ["brightnessctl", "set", percent + "%"];
                    brightnessSetProc.running = true;
                }
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
                        color: Appearance.m3colors.m3tertiary

                        Behavior on height {
                            NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
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
