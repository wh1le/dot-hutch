import QtQuick
import Qt5Compat.GraphicalEffects

Item {
    id: root

    property alias source: img.source
    property alias fillMode: img.fillMode
    property alias sourceSize: img.sourceSize
    property alias asynchronous: img.asynchronous
    property alias smooth: img.smooth
    property alias mipmap: img.mipmap
    property alias cache: img.cache
    property alias status: img.status

    // Fade amounts per edge (0.0 = no fade, 1.0 = full fade)
    property real fadeLeft: 0
    property real fadeRight: 0
    property real fadeTop: 0
    property real fadeBottom: 0

    Image {
        id: img
        anchors.fill: parent

        layer.enabled: true
        layer.effect: OpacityMask {
            maskSource: mask
        }
    }

    Rectangle {
        id: mask
        anchors.fill: parent
        layer.enabled: true
        visible: false
        color: "white"

        // Left fade
        Rectangle {
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: parent.width * root.fadeLeft
            visible: root.fadeLeft > 0
            gradient: Gradient {
                orientation: Gradient.Horizontal
                GradientStop { position: 0.0; color: "transparent" }
                GradientStop { position: 1.0; color: "white" }
            }
        }

        // Right fade
        Rectangle {
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: parent.width * root.fadeRight
            visible: root.fadeRight > 0
            gradient: Gradient {
                orientation: Gradient.Horizontal
                GradientStop { position: 0.0; color: "white" }
                GradientStop { position: 1.0; color: "transparent" }
            }
        }

        // Top fade
        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            height: parent.height * root.fadeTop
            visible: root.fadeTop > 0
            gradient: Gradient {
                GradientStop { position: 0.0; color: "transparent" }
                GradientStop { position: 1.0; color: "white" }
            }
        }

        // Bottom fade
        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: parent.height * root.fadeBottom
            visible: root.fadeBottom > 0
            gradient: Gradient {
                GradientStop { position: 0.0; color: "white" }
                GradientStop { position: 1.0; color: "transparent" }
            }
        }
    }
}
