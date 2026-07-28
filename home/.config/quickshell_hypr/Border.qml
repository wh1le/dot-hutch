import QtQuick
import QtQuick.Effects
import "modules/common"

Item {
    id: root
    required property real borderWidth
    required property real cornerRadius
    anchors.fill: parent

    Rectangle {
        anchors.fill: parent
        color: Appearance.colors.colBarBg

        layer.enabled: true
        layer.effect: MultiEffect {
            maskSource: mask
            maskEnabled: true
            maskInverted: true
            maskThresholdMin: 0.5
            maskSpreadAtMin: 1
        }
    }

    Item {
        id: mask
        anchors.fill: parent
        layer.enabled: true
        visible: false

        Rectangle {
            anchors.fill: parent
            anchors.topMargin: Appearance.sizes.barHeight
            anchors.leftMargin: 30
            anchors.rightMargin: root.borderWidth
            anchors.bottomMargin: 0
            radius: root.cornerRadius
        }
    }
}
