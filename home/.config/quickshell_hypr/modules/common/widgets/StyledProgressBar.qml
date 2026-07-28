pragma ComponentBehavior: Bound
import ".."
import QtQuick
import QtQuick.Controls

ProgressBar {
    id: root
    property real valueBarWidth: 120
    property real valueBarHeight: 4
    property real valueBarGap: 4
    property color highlightColor: Appearance?.colors.colPrimary ?? "#685496"
    property color trackColor: Appearance?.m3colors.m3secondaryContainer ?? "#F1D3F9"

    Behavior on value {
        animation: Appearance?.animation.elementMoveEnter.numberAnimation.createObject(this)
    }

    background: Item {
        implicitHeight: valueBarHeight
        implicitWidth: valueBarWidth
    }

    contentItem: Item {
        id: contentItem
        anchors.fill: parent

        Rectangle {
            anchors.left: parent.left
            width: contentItem.width * root.visualPosition
            height: contentItem.height
            radius: height / 2
            color: root.highlightColor
        }
        Rectangle {
            anchors.right: parent.right
            width: (1 - root.visualPosition) * parent.width - valueBarGap
            height: parent.height
            radius: height / 2
            color: root.trackColor
        }
        Rectangle {
            anchors.right: parent.right
            width: valueBarGap
            height: valueBarGap
            radius: height / 2
            color: root.highlightColor
        }
    }
}
