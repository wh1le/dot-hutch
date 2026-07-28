pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import ".."

Item {
    id: root

    property real value: 0
    property string icon: "volume_up"
    property color accentColor: Appearance.m3colors.m3primary
    property bool osdVisible: false
    property bool osdPaused: false

    signal moved(real newValue)
    signal iconClicked()

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

    Rectangle {
        anchors.fill: parent
        color: Appearance.colors.colBarBg
        topLeftRadius: Appearance.rounding.verysmall
        bottomLeftRadius: Appearance.rounding.verysmall

        ColumnLayout {
            anchors.fill: parent
            anchors.topMargin: 10
            anchors.bottomMargin: 10
            spacing: 6

            property bool showValue: false

            // Icon / percentage
            Item {
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: 24
                Layout.preferredHeight: 24

                MaterialSymbol {
                    anchors.centerIn: parent
                    iconSize: 16
                    fill: 1
                    text: root.icon
                    color: root.accentColor
                    opacity: parent.parent.showValue ? 0 : 1
                    scale: parent.parent.showValue ? 0.5 : 1
                    Behavior on opacity { NumberAnimation { duration: 200 } }
                    Behavior on scale { NumberAnimation { duration: 200 } }
                }

                StyledText {
                    anchors.centerIn: parent
                    text: Math.round(root.value * 100)
                    color: Appearance.m3colors.m3onSurface
                    font.pixelSize: Appearance.font.pixelSize.small
                    font.weight: Font.DemiBold
                    opacity: parent.parent.showValue ? 1 : 0
                    scale: parent.parent.showValue ? 1 : 0.5
                    Behavior on opacity { NumberAnimation { duration: 150 } }
                    Behavior on scale { NumberAnimation { duration: 150 } }
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.iconClicked()
                }

                Timer {
                    id: valueHideTimer
                    interval: 500
                    onTriggered: parent.parent.showValue = false
                }
            }

            // Slider
            Slider {
                id: slider
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: 20
                Layout.fillHeight: true
                orientation: Qt.Vertical
                from: 0; to: 1
                value: root.value
                hoverEnabled: true

                onMoved: root.moved(slider.value)
                onValueChanged: {
                    parent.showValue = true;
                    if (!pressed) valueHideTimer.restart();
                }
                onPressedChanged: {
                    if (pressed) {
                        root.osdPaused = true;
                        valueHideTimer.stop(); parent.showValue = true;
                    } else {
                        root.osdPaused = false;
                        valueHideTimer.restart();
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
                        color: Appearance.m3colors.m3surfaceContainerHighest
                    }

                    Rectangle {
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.bottom: parent.bottom
                        width: slider.barW
                        height: Math.max(0, parent.height * (1 - slider.visualPosition))
                        radius: slider.barW / 2
                        color: root.accentColor
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
        onEntered: root.osdPaused = true
        onExited: root.osdPaused = false
    }
}
