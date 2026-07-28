pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import ".."

Slider {
    id: root

    property color filledColor: Appearance.m3colors.m3primary
    property color emptyColor: Appearance.m3colors.m3surfaceContainerHighest
    property color handleColor: Appearance.m3colors.m3primary
    property real trackWidth: 25
    property real handleGap: 6
    property real handleSize: pressed ? 2 : 4

    orientation: Qt.Vertical
    from: 0
    to: 1
    hoverEnabled: true

    MouseArea {
        anchors.fill: parent
        cursorShape: root.pressed ? Qt.ClosedHandCursor : Qt.PointingHandCursor
        onPressed: mouse => {
            var pos = 1 - ((mouse.y - root.topPadding) / root.availableHeight);
            pos = Math.max(0, Math.min(1, pos));
            root.value = root.from + (pos * (root.to - root.from));
            mouse.accepted = false;
        }
    }

    background: Item {
        width: root.availableWidth
        height: root.availableHeight
        x: root.leftPadding
        y: root.topPadding

        readonly property real trackSize: root.trackWidth
        readonly property real availTrack: root.availableHeight - root.handleGap * 2
        readonly property real invertedPos: 1 - root.visualPosition

        // Empty track (top)
        Rectangle {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            width: parent.trackSize
            height: {
                let h = root.handleGap + ((1 - parent.invertedPos) * parent.availTrack) - (root.handleSize / 2 + root.handleGap);
                return Math.max(0, h);
            }
            radius: parent.trackSize / 2
            color: root.emptyColor
        }

        // Filled track (bottom)
        Rectangle {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            width: parent.trackSize
            height: {
                let h = root.handleGap + (parent.invertedPos * parent.availTrack) - (root.handleSize / 2 + root.handleGap);
                return Math.max(0, h);
            }
            radius: parent.trackSize / 2
            color: root.filledColor
        }
    }

    handle: Rectangle {
        anchors.horizontalCenter: parent.horizontalCenter
        y: root.topPadding + root.handleGap + ((1 - (1 - root.visualPosition)) * (root.availableHeight - root.handleGap * 2)) - height / 2
        width: root.availableWidth
        height: root.handleSize
        radius: height / 2
        color: root.handleColor

        Behavior on height {
            NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
        }
    }
}
