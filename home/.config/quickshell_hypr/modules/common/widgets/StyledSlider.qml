pragma ComponentBehavior: Bound
import ".."
import "."
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Slider {
    id: root

    property list<real> stopIndicatorValues: [1]
    property real handleDefaultWidth: 3
    property real handlePressedWidth: 1.5
    property color highlightColor: Appearance.colors.colPrimary
    property color trackColor: Appearance.colors.colSecondaryContainer
    property color handleColor: Appearance.colors.colPrimary
    property real trackWidth: 18
    property real trackRadius: 6
    property real handleHeight: Math.max(33, trackWidth + 9)
    property real handleWidth: root.pressed ? handlePressedWidth : handleDefaultWidth
    property real handleMargins: 4
    property real trackDotSize: 3
    property bool usePercentTooltip: true
    property string tooltipContent: usePercentTooltip ? `${Math.round(((value - from) / (to - from)) * 100)}%` : `${Math.round(value)}`

    leftPadding: handleMargins
    rightPadding: handleMargins
    property real effectiveDraggingWidth: width - leftPadding - rightPadding

    Layout.fillWidth: true
    from: 0
    to: 1

    Behavior on value {
        SmoothedAnimation { velocity: Appearance.animation.elementMoveFast.velocity }
    }

    MouseArea {
        anchors.fill: parent
        onPressed: (mouse) => mouse.accepted = false
        cursorShape: root.pressed ? Qt.ClosedHandCursor : Qt.PointingHandCursor
    }

    background: Item {
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        width: root.width
        implicitHeight: root.trackWidth

        // Fill (left of handle)
        Rectangle {
            anchors.verticalCenter: parent.verticalCenter
            width: root.leftPadding + (root.visualPosition * root.effectiveDraggingWidth)
            height: root.trackWidth
            color: root.highlightColor
            radius: root.trackRadius
        }

        // Track (right of handle)
        Rectangle {
            anchors.verticalCenter: parent.verticalCenter
            x: root.leftPadding + (root.visualPosition * root.effectiveDraggingWidth) + root.handleMargins + root.handleWidth / 2
            width: Math.max(0, root.effectiveDraggingWidth * (1 - root.visualPosition) - root.handleMargins - root.handleWidth / 2 + root.rightPadding)
            height: root.trackWidth
            color: root.trackColor
            radius: root.trackRadius
        }
    }

    handle: Rectangle {
        implicitWidth: root.handleWidth
        implicitHeight: root.handleHeight
        x: root.leftPadding + (root.visualPosition * root.effectiveDraggingWidth) - (root.handleWidth / 2)
        anchors.verticalCenter: parent.verticalCenter
        radius: Appearance.rounding.full
        color: root.handleColor

        Behavior on implicitWidth {
            animation: Appearance?.animation.elementMoveFast.numberAnimation.createObject(this)
        }
    }
}
